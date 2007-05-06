Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbXEFH4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbXEFH4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 03:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755470AbXEFH4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 03:56:11 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:60103 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbXEFH4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 03:56:10 -0400
Date: Sun, 6 May 2007 09:53:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <463CF7F8.7080007@interia.pl>
Message-ID: <Pine.LNX.4.61.0705060953210.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr> 
 <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com>
 <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr>
 <463CE1FB.4050305@interia.pl> <Pine.LNX.4.61.0705052237580.18504@yvahk01.tjqt.qr>
 <463CF7F8.7080007@interia.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5 2007 23:32, Rafał Bilski wrote:
>
>Is patch attached below making things better?
>You should see in log that You are using VT8235 support now.

Yeah, but locks up too.



Jan
-- 
