Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYJ1R7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYJ1R7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYJ1R7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:59:09 -0400
Received: from mail-gx0-f18.google.com ([209.85.217.18]:53700 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYJ1R7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vGmLMf714RIRMzUugAEZz4utqqR+fka69GYthgyvPaEu6X+JR2Eafx54SEIkbtFKsG
         4gNvS/fKDhYUIHZixfMluG1Pk4CBzP0kN9E0ZvxOXZ4D/1gr4MbGD0+c7bIBTj8cvXl4
         xZYEoKnsnr+P34pF0Bk1+d4vBGhF2qznPrOjI=
Message-ID: <72dbd3150810281059u478b3a77g1d5a52efbb5bea67@mail.gmail.com>
Date: Tue, 28 Oct 2008 10:59:06 -0700
From: "David Rees" <drees76@gmail.com>
To: "Oskar Liljeblad" <oskar@osk.mine.nu>
Subject: Re: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081028170105.GA21933@osk.mine.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028170105.GA21933@osk.mine.nu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 10:01 AM, Oskar Liljeblad <oskar@osk.mine.nu> wrote:
> Can anyone make any sense of these SATA errors? They're killing my md RAID5
> (at least the second error did).
>
> Hard drives (ata1/sda, ata2/sdb, ata3/sdc): Seagate ST31500341AS 1.5TB SATA
> Motherboard: Asus M3A78-EH with AMD 780G/SB700 chipset
> SATA driver: ahci
> 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [AHCI mode]

Seems to be a known issue with the 1.5TB drives and Linux (and Mac users, too)

http://forums.seagate.com/stx/board/message?board.id=ata_drives&thread.id=2390
http://ubuntuforums.org/showthread.php?t=933053

-Dave
