Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbYGaCZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbYGaCZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYGaCZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:25:10 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:34022 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466AbYGaCZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=U8UYtRiR+ujSq+1In+Y3vjkkHgGEVmuw7ZP5NOCR+RyETUiBn+ueZQUWzaogqcI92g
         4bPZaXoJ/BK4VkdkXC7mf7Qj9Mm31LXmIGsA7MgHrM2AgdDE33SFXO+870K4Q50QTvnw
         AKC5KRHHpQBPa0DVLNCJqvp6xMFAmztVd0UGc=
Message-ID: <dd18b0c30807301925m4302807by2d044f853ff5ad44@mail.gmail.com>
Date: Wed, 30 Jul 2008 19:25:04 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: irq 23: nobody cared
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when loading 2.6.27-rc1 every so often(maybe 5 or 7 reboots)
Im confronted with the system reacting very slowly,
and giving me this message:

[19.086483] irq 23: nobody cared (try booting with the "irqpoll" option)
[19.090002] handlers
[19.090002][<c02cbb49>] (usb_hcd_irq+0x0/0x77)
[19.090002][<c02cbb49>] (usb_hcd_irq+0x0/0x77)
Disabling irq #23

then the login screen appears and when typing a letter results in two letters
of the same letter.
regards;
-- 
Justin P. Mattock
