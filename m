Return-Path: <linux-kernel-owner+w=401wt.eu-S1767635AbXCIXXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767635AbXCIXXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 18:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767642AbXCIXXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 18:23:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60356 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767635AbXCIXXL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 18:23:11 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: irq nobody cared issue on 2.6.2x
Date: Sat, 10 Mar 2007 00:22:57 +0100
User-Agent: KMail/1.9.5
References: <200703072048.49637.mws@twisted-brains.org>
In-Reply-To: <200703072048.49637.mws@twisted-brains.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703100022.57582.hpj@urpla.net>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:18d01dd0a2a377f0376b761557b5e99a
X-Provags-ID2: V01U2FsdGVkX1/CErDM3zxXM5K3xA0Ph98C5HggxmXx7vTPxzZ
 DkCuUuvQgXgRaI4nLQQd+8VaBZPJvD4JBZPuzYeK0U2WDEcT8h
 i8iPdXqWNwFj+GJV2kr9g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. März 2007 20:48 schrieb Mws:
> hi all,
>
> i just moved my win tv dvb-s card (PCI) from my old to my actual pc.
>
> its an ASUS M2N32 WS Professional AMD64 X2 Board equiped with
> the nvidia nForce 590 SLI MCP chipset.
>
> in the past, i had to use the noapic kernel cmdline param to get linux
> booting and working properly.
>
> iirc versions >=2.6.18 of the kernel fixed all of my previous problems,
> thus i am not using noapic since then.

Hmm, I'm using the same board here since two weeks. openSUSE 10.2 (i586, 
kernel 2.6.18.{2,8}) didn't installed properly even with noapic (problems 
with eth device while installing from nfs server :-(, temporarily work 
arounded with an e1000). I found a BIOS update necessary for proper apic 
operation. No problems since then, but not using a dvb card in there 
either, since my vdr is a seperate system ;-)..

Cheers,
   Pete
