Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbXIAGLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbXIAGLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 02:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbXIAGK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 02:10:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48590 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXIAGKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 02:10:45 -0400
Date: Sat, 1 Sep 2007 08:10:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Robert Hancock <hancockr@shaw.ca>
cc: Clemens Kolbitsch <clemens.kol@gmx.at>,
       Chris Smith <smitty1elkml@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Copy large memory regions from & to userspace
In-Reply-To: <46D8C4DC.2080307@shaw.ca>
Message-ID: <Pine.LNX.4.64.0709010810070.11617@fbirervta.pbzchgretzou.qr>
References: <fa.0TqRgC3Smn96vb+Bwv5QRWKBTQg@ifi.uio.no>
 <fa.x2L04usZZxVIMYSdrufu+Hen9aY@ifi.uio.no> <fa.tMlh7ZYvNMxPEL69Eww8ErwDEmw@ifi.uio.no>
 <46D8C4DC.2080307@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 31 2007 19:48, Robert Hancock wrote:
>
> I'm not aware of any code in the kernel that does userspace-to-userspace
> copies directly. Likely because there's rarely a need for it?

splice(), sort of.



	Jan
-- 
