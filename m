Return-Path: <linux-kernel-owner+w=401wt.eu-S932805AbZJGU1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbZJGU1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbZJGU1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:27:09 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:59055 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760031AbZJGU1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:27:08 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2009 16:27:07 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:user-agent:x-archive:mime-version
         :content-type;
        b=mmT3SbSmVP1R7tH/PwmP5bXLHOKLjc4B/3ViAwRgtBLlnpoHiiqp7A5MPU3x8hSAsV
         c93NbeTnzvAnFVxX0KHG8IC4KY1DnWcIaJ9yHDNlRsbAG6KTDIW9lwpNQKgwgwALwcva
         wnDzWu61BI4h42z1cftzMbF1sKdccHMRZmugw=
Date: Wed, 7 Oct 2009 17:19:25 -0300 (BRST)
From: "=?ISO-8859-15?Q?Fr=E9d=E9ric_L=2E_W=2E_Meunier?=" 
	<fredlwm@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: keyboard under X with 2.6.31
Message-ID: <alpine.LNX.2.01.0910071706490.11297@dyndns.pervalidus.net>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
X-Archive: encrypt
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My keyboard (ABNT2 PS/2) seems to be broken under X with 
2.6.31.2. After less than an hour, it starts acting crazy. The 
first time, all leds turned off and I couldn't type anything. 
The second time, all leds also turned off, but since it happened 
while I was pressing the Backspace key to delete text, it 
continued deleting, like if the key was pressed.

In both cases, the mouse (USB) still works and I can exit X, 
where the keyboard works. There's nothing in the logs.

No problem with 2.6.30.9. Is it supposed to be a kernel or X bug 
?
