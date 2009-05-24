Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbZEXPcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbZEXPcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755187AbZEXPcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:32:42 -0400
Received: from smtpout10.uol.com.br ([200.221.4.201]:38063 "EHLO
	smtp.uol.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754573AbZEXPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:32:42 -0400
Date: Sun, 24 May 2009 12:32:30 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@ime.usp.br>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: ioctl_internal_command messages (was: Re: [2.6.30-rc2] usb reset
	during big file transfer and ext3 error)
Message-ID: <20090524153230.GA6246@ime.usp.br>
References: <20090524071637.GA5487@ime.usp.br> <Pine.LNX.4.44L0.0905241035380.7718-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0905241035380.7718-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: 605b6b41e82f6bc6b3367501225e2483
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 24 2009, Alan Stern wrote:
> On Sun, 24 May 2009, [utf-8] RogÃ©rio Brito wrote:
> > In particular, those ioctl_internal_command return code messages seem
> > strange, regarding other USB devices that I have. Are they being shown
> > because I have some debugging information in my kernel or are they
> > abnormal?
> 
> It is abnormal, but I can't tell what the reason is without more 
> information.  You should try using usbmon (see 
> Documentation/usb/usbmon.txt) to trace these events.

Recompiling my kernel right now with usbmon support. Will send you logs
very soon.


Thanks,

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
