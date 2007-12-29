Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbXL2XDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbXL2XDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 18:03:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbXL2XDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 18:03:15 -0500
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:54981 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbXL2XDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 18:03:14 -0500
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as well
Date: Sun, 30 Dec 2007 00:03:09 +0100
User-Agent: KMail/1.9.7
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712210309.02865.volker.armin.hemmann@tu-clausthal.de> <20071221111921.GB687@elte.hu>
In-Reply-To: <20071221111921.GB687@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712300003.09946.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

you guys were right, I was wrong.

It is the hardware. 

I increased ram voltage by 0.15V on the 22nd and hadn't any oopses since then. 
And I did torture the system.

I am deeply sorry that I wasted your time (but still puzzled that the oopses 
started after kernel update - maybe I should buy a new psu... ).

So it is not reiser4  nor the kernel, just the ram needs a little more 'juice' 
than the board delivers on 'auto' settings.

Glück Auf
Volker
