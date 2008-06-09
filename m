Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbYFIP4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbYFIP4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYFIP4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:56:23 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:12177 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYFIP4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:56:22 -0400
X-IronPort-AV: E=Sophos;i="4.27,613,1204531200"; 
   d="scan'208";a="110737933"
From: Roland Dreier <rdreier@cisco.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: update checkpatch.pl to version 0.19
References: <200806061922.m56JMJuq025990@hera.kernel.org>
	<20080606233037.GA8548@kroah.com>
	<20080606230239.c1a8c002.akpm@linux-foundation.org>
	<20080607173436.GA17603@kroah.com>
	<20080609083301.GA6701@shadowen.org>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 09 Jun 2008 08:56:19 -0700
In-Reply-To: <20080609083301.GA6701@shadowen.org> (Andy Whitcroft's message of
	"Mon, 9 Jun 2008 09:33:01 +0100")
Message-ID: <ada3anma9gc.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jun 2008 15:56:19.0690 (UTC) FILETIME=[5B849CA0:01C8CA49]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > The issue I have is I have a comprehensive test suite which is kept in
 > lock step with checkpatch itself, all in my own tree.  Now that is just
 > noise for mainline.  What I want to be able to do is keep that in lock
 > step with developments in my tree, but not merge it upstream.  So far
 > I've not found a workable solution with git for that.

>From my naive point of view: why wouldn't we want a test suite upstream,
if one is already written?

 - R.
