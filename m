Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbXEVWoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbXEVWoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755877AbXEVWn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:43:56 -0400
Received: from mx.laposte.net ([81.255.54.16]:29642 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbXEVWnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:43:55 -0400
X-Greylist: delayed 1210 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 18:43:55 EDT
Date: Wed, 23 May 2007 00:23:43 +0200
Message-Id: <JIGRJJ$5921B4BBD75CCBFCB931C58F85C25D21@laposte.net>
Subject: [INPUT] i8042 not detecting AUX port
MIME-Version: 1.0
X-Sensitivity: 3
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdOk=?= <emmanuel.fuste@laposte.net>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "dmitry\.torokhov" <dmitry.torokhov@gmail.com>
X-XaM3-API-Version: 4.1 (B103)
X-SenderIP: 127.0.0.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just to let you know that since I jumped from 2.6.16 to
2.6.20.7 and 2.6.21, I need the i8042.noloop option to get the
AUX port detected.
Without this option, the kernel silently omit the AUX port,
only the KBD port is detected.

If Dmitry is interested by a debug log, I will recompile a
kernel with i8042.debug support.
I will try first to add the patch from Roland Scheidegger
witch is in the Linus tree.

Emmanuel.
---

Créez votre adresse électronique prenom.nom@laposte.net 
1 Go d'espace de stockage, anti-spam et anti-virus intégrés.

