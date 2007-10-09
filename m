Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbXJITj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbXJITj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbXJITjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:39:19 -0400
Received: from khc.piap.pl ([195.187.100.11]:33508 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbXJITjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:39:18 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Timur Tabi <timur@freescale.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>
	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>
	<470691EB.7020209@freescale.com>
	<AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>
	<4706A842.9030507@freescale.com>
	<20071009174623.GC4003@csclub.uwaterloo.ca>
	<470BC0D5.70305@freescale.com> <m3fy0kcec4.fsf@maximus.localdomain>
	<470BD266.8020302@goop.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 09 Oct 2007 21:39:16 +0200
In-Reply-To: <470BD266.8020302@goop.org> (Jeremy Fitzhardinge's message of "Tue, 09 Oct 2007 12:11:34 -0700")
Message-ID: <m33awkcc2j.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

>> There is no such thing as bit-order. The data lines are numbered,
>> say, D0 - D31, with D0 being LSB (bit) and D31 MSB.
>>   
>
> Uh-huh.  Check out an IBM Power manual some time.

Some pointer maybe?
-- 
Krzysztof Halasa
