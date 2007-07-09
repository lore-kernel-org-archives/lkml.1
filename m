Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbXGIKaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbXGIKaO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXGIKaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:30:04 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:18266 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXGIKaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:30:01 -0400
Date: Mon, 9 Jul 2007 12:30:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
In-Reply-To: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707091224160.32335@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Jul 8 2007 16:52, Linus Torvalds wrote:
>
>So this is also a heads-up that I'm considering skipping the ChangeLog 
>files in the future - the full release ones are so big as to not be very 
>easily readable (the full ChangeLog from 2.6.21 is ove ra hundred thousand 
>lines, and weighs in at 3.8MB for example), and you really can get much 
>better per-subsystem logs from git.
>
>Anybody? Should I make just the shortlogs available instead (I don't save 
>those, but I post those for the later -rc's - usually the -rc1 and -rc2's 
>are too big for the mailing list, but they are still a lot smaller and 
>more readable than the *full* logs are)?
>
>Or do people really want the full logs, and don't use git?
>
>Let me know how you feel. And test the actual release out too, of course!

The rc-to-rc shortlog is usually helpful. That way, I can see whether a
particular fix that I am interested in/involved with has already been
merged - or not and its needs some reminder. And the 2.6.x -> 2.6.y-rc1
shortlog for seeing whether patches, should I have decided to send
anything, actually went in. All other logs can be omitted from the mail
announcements. I still prefer to have all logs, as usual, both short
and long, via http (perhaps compressed for your pleasure), because
cloning a git is not always possible (think of public terminals) or
feasible (cloning does take a while, and longer on slower links).


	Jan
-- 
