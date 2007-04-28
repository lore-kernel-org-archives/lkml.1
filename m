Return-Path: <linux-kernel-owner+w=401wt.eu-S1031937AbXD1R6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031937AbXD1R6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031236AbXD1R6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:58:13 -0400
Received: from smtp21.orange.fr ([80.12.242.46]:14444 "EHLO smtp21.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031935AbXD1R54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:57:56 -0400
X-ME-UUID: 20070428175752869.D45481C0008C@mwinf2127.orange.fr
Message-ID: <46338AFB.1090308@wanadoo.fr>
Date: Sat, 28 Apr 2007 19:57:15 +0200
From: Thibaud Hulin <hulin.thibaud@wanadoo.fr>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Your /etc/kernel-img.conf needs to be updated
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !
I'm triying to compile the kernel 2.6.19.
The compilation happens good, but when I install the .deb on Debian 
testing, I get an out error state 1 :

Préparation du remplacement de linux-image-2.6.19.070428 2.6.19.suspend2
(en utilisant linux-image-2.6.19.070428_2.6.19.suspend2_i386.deb) ...
Ok, Aborting
dpkg : erreur de traitement de
linux-image-2.6.19.070428_2.6.19.suspend2_i386.deb (--install) :
  le sous-processus pre-installation script a retourné une erreur de
sortie d'état 1
Running postrm hook script /sbin/update-grub.
Your /etc/kernel-img.conf needs to be updated. Read grub's NEWS.Debian[1]
file and follow its instructions.


update-grub works normally, but don't change anything.
Where can I find informations about /etc/kernel-img.conf and grub's 
NEWS.Debian[1] ?

I don't understand what I must do.

Thanks for help,
Thibaud.

