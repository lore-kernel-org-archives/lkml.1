Return-Path: <linux-kernel-owner+w=401wt.eu-S938639AbXHIL3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938639AbXHIL3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 07:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbXHIL3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 07:29:09 -0400
Received: from alnrmhc13.comcast.net ([206.18.177.53]:53223 "EHLO
	alnrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759809AbXHIL3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 07:29:08 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Aug 2007 07:29:08 EDT
Subject: Re: Kernel / Fliesystem Error
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Chris Holvenstot <saltydog@houston.rr.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1186623555.6613.17.camel@localhost>
References: <1186623555.6613.17.camel@localhost>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 06:25:30 -0500
Message-Id: <1186658730.7018.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Chris Snook wrote:
>
>The problem here is that your clock is wrong either at mount (boot)
>time or unmount (shutdown) time. There's nothing wrong with ext3,
>except that it happens to be noticing this condition.


Chris - 

I appreciate the response but on the face of it I do not know if I
believe that this is the answer.  I am not the sharpest knife in the
drawer but the following two items still cast a doubt on the answer.

1.  This happens even when the system is rebooted via the shutdown -r
command - not much time for my fat fingers to get in there and dork up
the system clock.

2.  As I stated in the original note, this does NOT happen with kernel
2.6.22.1 - so far I have only seen it with the 2.6.23-rc1, rc2, and
rc2-git1 kernels.

Other than this I would say you were spot on in your analysis.  Maybe
there is something I don't understand here.  If so, pardon me for being
"Thick as a brick" 

Chris





