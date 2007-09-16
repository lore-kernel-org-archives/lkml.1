Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbXIPIMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbXIPIMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 04:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbXIPIMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 04:12:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56880 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXIPIMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 04:12:12 -0400
Message-ID: <46ECE554.5030308@garzik.org>
Date: Sun, 16 Sep 2007 04:12:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: "J.C. Roberts" <jcroberts@designtools.org>
CC: Kyle Moffett <mrmacman_g4@mac.com>, Jason Dixon <jason@dixongroup.net>,
       misc@openbsd.org, moglen@softwarefreedom.org, lessig_from_web@pobox.com,
       bkuhn@softwarefreedom.org, norwood@softwarefreedom.org,
       fontana@softwarefreedom.org, karen@softwarefreedom.org,
       linux-kernel@vger.kernel.org
Subject: Re: Wasting our Freedom
References: <5C8C3794-C62A-4935-8267-81080CCF6867@dixongroup.net> <200709150333.20384.jcroberts@designtools.org> <1B000B52-707E-4592-88CD-64BD88C6C9B2@mac.com> <200709160052.45493.jcroberts@designtools.org>
In-Reply-To: <200709160052.45493.jcroberts@designtools.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.7 (---)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-3.7 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

J.C. Roberts wrote:
> http://marc.info/?l=linux-wireless&m=118857712529898&w=2

Link with outdated info.


> http://madwifi.org/browser/branches/ath5k

Link with outdated info.


> I suggest actually taking the time to get the facts before making 
> completely baseless statements. When you make obviously erroneous 
> statements, it leaves everyone to believe you are either hopelessly 
> misinformed, or a habitual liar. -Which is it?

Please take a moment to understand the Linux development process.

A better place to look would be 'ath5k' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-dev.git

but nonethless, the fact remains that ath5k is STILL NOT UPSTREAM and 
HAS NEVER BEEN UPSTREAM, as can be verified from

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	(official linux repo; nothing is official until it hits here)

Part of the reason why ath5k is not upstream is that developers are 
actively addressing these copyright concerns -- as can be clearly seen 
by the changes being made over time.

So let's everybody calm down, ok?

Regards,

	Jeff


