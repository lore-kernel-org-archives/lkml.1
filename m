Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYJ3FdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYJ3FdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 01:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYJ3FdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 01:33:00 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:52505 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYJ3Fc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:32:59 -0400
Message-ID: <49094701.3090601@t-online.de>
Date: Thu, 30 Oct 2008 06:32:49 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080926)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27.3, ata_piix: cannot play audio CD, "disk change detected"
References: <490615E9.7070607@t-online.de> <49061803.4060707@garzik.org>
In-Reply-To: <49061803.4060707@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ID: EwmQiTZZZhzo48FfseY0xV2XW0Jkne2KtVnlCJlsHeQBBipVFVacXuCIFJIElPSgDb
X-TOI-MSGID: 4476a881-6c18-4107-b2df-cbaf8603a815
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Can you try various strategies associated with interrupts (trying to
> determine the cause of the timeouts), such as booting with "noapic",
> "acpi=off", and/or pci=biosirq.
> 

I will check again at the weekend. Stay tuned.


Regards

Harri

