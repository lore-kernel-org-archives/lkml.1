Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbXHUTgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbXHUTgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757451AbXHUTgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:36:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57011 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757660AbXHUTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:36:08 -0400
Date: Tue, 21 Aug 2007 21:36:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Hex Star <hexstar@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Trouble booting with new 2.6.22.3 kernel
In-Reply-To: <5dc6fd9e0708211229q7c5df3a2q9ce00244d1b20019@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708212135040.20435@fbirervta.pbzchgretzou.qr>
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com> 
 <200708212225.51987.ismail@pardus.org.tr>  <5dc6fd9e0708211228u433dbe04n7ca69e8b78ae29d@mail.gmail.com>
 <5dc6fd9e0708211229q7c5df3a2q9ce00244d1b20019@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 21 2007 12:29, Hex Star wrote:
>
>Btw, I am not using a initramfs image..

success = (using_initramfs && ide == 'M') || ide == 'Y';

HTH.


	Jan
-- 
