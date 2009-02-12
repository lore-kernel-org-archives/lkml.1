Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbZBLVWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbZBLVWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZBLVWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:22:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:21002 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZBLVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Qb95F8R93Fa07JXF3bmKlIab36Fd/CaXtrsK1n3jxgzNT/J6EbZ5oUXcGyH+Il0TyZ
         9qJHQCigN34Vo7Ep1ISsb0lWcvWNnaMuQC7DIDJBCD0M9W70zbjWdefQxHmjKp841xp6
         DPNeJitTYlaeQ98mXQ2X78UOsqBGVroLUqOHY=
MIME-Version: 1.0
In-Reply-To: <20090128113809.GA29424@elf.ucw.cz>
References: <20090128113809.GA29424@elf.ucw.cz>
Date: Thu, 12 Feb 2009 22:22:37 +0100
X-Google-Sender-Auth: 7f2a74fa67d8e67e
Message-ID: <dc2200690902121322l4e16cf84h25d2871ca80c37a3@mail.gmail.com>
Subject: Re: 2.6.29-rc1 on zaurus (spitz)
From: =?windows-1252?Q?Cyril_Hrubi=9A?= <metan@ucw.cz>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, Dirk@opfer-online.de, arminlitzel@web.de,
       pavel.urban@ct.cz, thommycheck@gmail.com, milan@ucw.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
2.6.29-rc4 boots on spitz and looks overall good but framebuffer
redraws some lines terribly slow. When I'm editing text in bash from
the middle in some cases I can see redrawing the text pixel by pixel.
And suspend to ram on pressing On/Off button does nothing now (some
missing config option?).
-- 
watashi |v|3+@n
Cyril Hrubis
metan@ucw.cz
http://atrey.karlin.mff.cuni.cz/~metan/
