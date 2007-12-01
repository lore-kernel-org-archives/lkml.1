Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbXLAMN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbXLAMN5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 07:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753030AbXLAMNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 07:13:44 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33936 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbXLAMNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 07:13:43 -0500
Date: Sat, 1 Dec 2007 13:13:42 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org, apiszcz@solarrain.com
Subject: Re: Kernel 2.6.23.9 / P35 Chipset + WD 750GB Drives (reset port)
In-Reply-To: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
Message-ID: <Pine.LNX.4.64.0712011310410.30316@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0712010619150.25643@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 1 2007 06:26, Justin Piszcz wrote:
> I ran the following:
>
> dd if=/dev/zero of=/dev/sdc
> dd if=/dev/zero of=/dev/sdd
> dd if=/dev/zero of=/dev/sde
>
> (as it is always a very good idea to do this with any new disk)

Why would you care about what's on the disk? fdisk, mkfs and
the day-to-day operation will overwrite it _anyway_.

(If you think the disk is not empty, you should look at it
and copy off all usable warez beforehand :-)

