Return-Path: <linux-kernel-owner+w=401wt.eu-S934277AbYBUVJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934277AbYBUVJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760182AbYBUVJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:09:34 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:42293 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758819AbYBUVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:09:32 -0500
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
X-Message-Flag: Warning: May contain useful information
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	<20080221154951.GA28328@cs181133002.pp.htv.fi>
	<adahcg2awag.fsf@cisco.com>
	<20080221210124.GD28328@cs181133002.pp.htv.fi>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 21 Feb 2008 13:09:27 -0800
In-Reply-To: <20080221210124.GD28328@cs181133002.pp.htv.fi> (Adrian Bunk's message of "Thu, 21 Feb 2008 23:01:24 +0200")
Message-ID: <adamypu9fug.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Feb 2008 21:09:28.0078 (UTC) FILETIME=[0B3E5AE0:01C874CE]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Is it really intended to merge drivers without _any_ kind of review?
 > 
 > This driver even lacks a basic "please fix the > 250 checkpatch errors" [1]
 > and similar low hanging fruits that could easily be spotted and then 
 > fixed by the submitter within a short amount of time.

Just to be clear, this driver was reviewed.  Many issues were found,
and many were fixed while others are being worked on.

It's a judgement call when to merge things, but in this case given the
good engagement from the vendor, I didn't see anything to be gained by
delaying the merge.

 - R.
