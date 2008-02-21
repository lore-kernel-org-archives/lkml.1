Return-Path: <linux-kernel-owner+w=401wt.eu-S1765113AbYBUXiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765113AbYBUXiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756552AbYBUXiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:38:16 -0500
Received: from khc.piap.pl ([195.187.100.11]:37286 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbYBUXiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:38:16 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>
	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>
	<20080221154951.GA28328@cs181133002.pp.htv.fi>
	<adahcg2awag.fsf@cisco.com>
	<20080221210124.GD28328@cs181133002.pp.htv.fi>
	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 22 Feb 2008 00:38:14 +0100
In-Reply-To: <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 21 Feb 2008 13\:14\:55 -0800 \(PST\)")
Message-ID: <m3tzk1q3rt.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> I'm personally of the opinion that a lot of checkpatch "fixes" are 
> anything but. That mainly concerns fixing overlong lines

Perhaps we should increase line length limit, 132 should be fine.
Especially useful with long printk() lines and long arithmetic
expressions.
-- 
Krzysztof Halasa
