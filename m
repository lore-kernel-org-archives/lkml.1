Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbZKWVMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbZKWVMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbZKWVMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:12:32 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbZKWVMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:12:31 -0500
Date: 23 Nov 2009 22:11:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: khc@pm.waw.pl
Cc: dmitry.torokhov@gmail.com
Cc: j@jannau.net
Cc: jarod@redhat.com
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: mchehab@redhat.com
Cc: superm1@ubuntu.com
Message-ID: <BDRae8rZjFB@christoph>
In-Reply-To: <m36391tjj3.fsf@intrepid.localdomain>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+2CGruSPmJ8Kbdv5teM38CaHVXT6GlteBhyBm
 eigBnJkCOuM+93RZ/ens09plWf44Y708E1hT9rHiP9xcQyooFC
 fklxhCxB/kwbvj2peey4dq3kB1m2p/d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Czesc Krzysztof,

on 23 Nov 09 at 15:14, Krzysztof Halasa wrote:
[...]
> I think we shouldn't at this time worry about IR transmitters.

Sorry, but I have to disagree strongly.
Any interface without transmitter support would be absolutely unacceptable  
for many LIRC users, including myself.

Christoph
