Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYCOWWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYCOWWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 18:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYCOWW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 18:22:26 -0400
Received: from smtp.ertelecom.ru ([212.33.232.210]:4636 "EHLO
	smtp.ertelecom.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbYCOWW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 18:22:26 -0400
X-Greylist: delayed 2839 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Mar 2008 18:22:25 EDT
Message-ID: <47DC4104.1070109@permonline.ru>
Date: Sun, 16 Mar 2008 02:35:00 +0500
From: "Artem S. Tashkinov" <birdie@permonline.ru>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: GIT commit description flag(s)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice if [kernel] git commits had a flag [a char] (or a 
combination of) describing their main purpose which could be the following:

bug Fix [F]
Speed up/Performance [S]
Revert [R]
New functionality [N]

etc.

So a particular commit at 
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=summary

will look like:

19 hours ago 	Ingo Molnar 	sched: fix fair sleepers 	[F] commit | 
commitdiff | tree | snapshot

This way it will be much easier to keep track of important changes 
happening to the kernel.


--

Thanks for your attention,

Artem S. Tashkinov
