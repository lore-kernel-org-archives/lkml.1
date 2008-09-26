Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbYIZJqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbYIZJqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 05:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYIZJqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 05:46:08 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:55800 "EHLO netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYIZJqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 05:46:07 -0400
X-Greylist: delayed 914 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2008 05:46:06 EDT
Message-ID: <2e8201c91fba$1befac80$0400a8c0@dcccs>
From: "Janos Haar" <djani22@netcenter.hu>
To: <linux-kernel@vger.kernel.org>
Subject: Whats going on? (somebody can say something?)
Date: Fri, 26 Sep 2008 11:27:27 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

Good day for everibody.

I have one problem with my new linux box. (again)
The hw is tested. (memtest86, 4 days)

The samba freezed and makes 40 load.

All what i am using is in-kernel solution, excepting samba.

libata ->bock -> raid -> cryptoloop -> xfs -> [samba] ->eth

The log file is here:

http://download.netcenter.hu/bughunt/20080925/messages

some points:
Sep 24 01:15:58 - Sep 24 01:19:16 -> i have repaired the 2 xfs on loop0 and 
loop1Sep 24 14:18:00 -> only a little interesting time, when the first bug 
was issued. (cron?)Sep 25 21:47:39 -> i have logged in.Sep 25 21:50:50 -> i 
have forced the sysreq from script to make some more debug information.(I 
have saved the lsof too if somebody interested.)Any help will be 
appreciated.Thanks a lot,Janos Haar 

