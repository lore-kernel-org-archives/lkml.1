Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbXJITMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbXJITMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 15:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbXJITMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 15:12:24 -0400
Received: from gw.goop.org ([64.81.55.164]:53165 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbXJITMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 15:12:24 -0400
Message-ID: <470BD266.8020302@goop.org>
Date: Tue, 09 Oct 2007 12:11:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Timur Tabi <timur@freescale.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
References: <4706822D.4070509@freescale.com>	<Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr>	<470691EB.7020209@freescale.com>	<AECA61F9-0EF6-4883-9D37-004C00C57417@cam.ac.uk>	<4706A842.9030507@freescale.com>	<20071009174623.GC4003@csclub.uwaterloo.ca>	<470BC0D5.70305@freescale.com> <m3fy0kcec4.fsf@maximus.localdomain>
In-Reply-To: <m3fy0kcec4.fsf@maximus.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> There is no such thing as bit-order. The data lines are numbered,
> say, D0 - D31, with D0 being LSB (bit) and D31 MSB.
>   

Uh-huh.  Check out an IBM Power manual some time.

    J
