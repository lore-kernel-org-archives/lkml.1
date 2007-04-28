Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXD1VDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXD1VDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXD1VDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:03:55 -0400
Received: from mail.syneticon.net ([213.239.212.131]:32825 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXD1VDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:03:52 -0400
X-Greylist: delayed 1175 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Apr 2007 17:03:52 EDT
Message-ID: <4633B1CE.8050306@wpkg.org>
Date: Sat, 28 Apr 2007 22:42:54 +0200
From: Tomasz Chmielewski <tch@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:

> I do hereby promise you to manually ask the submitters of all 1600 open 
> bugs in the kernel Bugzilla within one month whether their problem is 
> still present with 2.6.21 and forwarding all bugs if the answer was 
> "yes" to whoever is the right recipient if you promise me that all bugs 
> where the submitter said "yes" will be debugged by a kernel developer 
> who knows the corresponding subsystem. [4]

Hmm.
I reported a bug on 2006-08-07 ("ISDN/hisax doesn't work on ARM 
architecture"):

http://bugzilla.kernel.org/show_bug.cgi?id=6970


There was not much activity there... and the bug is still opened in 
kernel's bugzilla.


However, I received two emails from Andrew Morton on 02.10.2006 - one 
with a patch, and the second (automated?) which said:

The patch titled

      isdn: work around excessive udelay()

has been removed from the -mm tree.  Its filename is

      isdn-work-around-excessive-udelay.patch

This patch was dropped because it was merged into mainline or a 
subsystem tree


I'm very happy that the bug was fixed, but why wasn't it automatically 
closed in bugzilla (I closed it only today as I looked up into bugzilla)?

Do we have some wrong communication here? How many bugs are there that 
are falsely opened, when in reality they were resolved long ago?


-- 
Tomasz Chmielewski
http://wpkg.org
