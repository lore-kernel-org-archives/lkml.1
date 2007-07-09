Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbXGIQAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbXGIQAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbXGIP7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 11:59:54 -0400
Received: from mailgw12.fraunhofer.de ([153.96.1.24]:39296 "EHLO
	mailgw12.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbXGIP7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 11:59:51 -0400
Date: Mon, 09 Jul 2007 17:57:38 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: linux-kernel@vger.kernel.org
Subject: Re: cdparanoia not setting count and/or reply_len properly
Message-ID: <46925af2.ynOFHQKDLEPR7bga%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Jul 2007 15:59:49.0293 (UTC) FILETIME=[2DA77DD0:01C7C242]
X-Fraunhofer-Email-Policy: accepted
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>It is probably about time that cdparanoia was updated ...

>Doug Gilbert

Cdparanoia was not updated since 2001. The here important low level code is 
still the same as with cdda2wav from 1997.

For this reason, I did create a portable libparanoia from the assets of the 
cdparanoia code and also fixed several bugs in the paranoia code.
We then added this code to a recent cdda2wav in April 2002.

People need to learn that cdparanoia is dead and no longer maintained by Monty.
Monty is working on other software now. A recent maintained version is here:

ftp://ftp.berlios.de/pub/cdrecord/alpha/

http://cdrecord.berlios.de/new/private/cdrecord.html

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       schilling@fokus.fraunhofer.de     (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/old/private/ ftp://ftp.berlios.de/pub/schily
