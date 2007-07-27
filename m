Return-Path: <linux-kernel-owner+w=401wt.eu-S937877AbXG0Viq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937877AbXG0Viq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 17:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbXG0Vii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 17:38:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:12450 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbXG0Vig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 17:38:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=M7+jxXjg8TAieEdZJXm261NAfq6nuJpuv/+gAX1wYjhl8pLuT3zfX6ws2S47wh8eZM17TgtS5aiSoGncdekuCVaikNx7H5l69hdAR1GryPHqwCSPuNbtLH1aN7hR6ES7F2+Ha4QdOTo6eZzjVjX92McUxcgaAsnZcR29wXG4T88=
Message-ID: <7fedbc910707271438t183bab6bxe295f161a5ec0fba@mail.gmail.com>
Date: Fri, 27 Jul 2007 23:38:36 +0200
From: shacky <shacky83@gmail.com>
To: "Jesper Juhl" <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel modules compilation
In-Reply-To: <9a8748490707271303h7f5187ffk31d211c34fd885bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7fedbc910707271211v2ac2c927k3dd8fec8643ee250@mail.gmail.com>
	 <9a8748490707271303h7f5187ffk31d211c34fd885bf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> You could start by telling people what modules you are talking about.

The modules I need are:

- bridge
- ipv6
- thermal
- fan
- button
- processor
- ac
- battery
- dm_snapshot
- tg3
- serio_raw
- pcspkr
- sata_svw
- libata
- i2c_piix4
- i2c_core
- tsdev
- reiserfs
- dm_mod
- sd_mod
- mptsas
- mptscsih
- mptbase
- scsi_transport_sas
- scsi_mod
- usbmouse
- usbhid
- usbkbd
- ohci_hcd
- ehci_hcd
- usbcore

I cannot found some of them in the kernel configuration.
Isn't there a general way to know what configuration compiles what
module in general?
I need to know this because I'm trying to compile a fully-optimized
version of the kernel for my xen0 domain on my amd64 system.
Is the "lsmod" way correct to find what modules I have to compile to
have a correctly-booting system with a very very small kernel?

Thank you very much for your help!
Bye.
