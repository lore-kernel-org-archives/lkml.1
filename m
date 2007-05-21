Return-Path: <linux-kernel-owner+w=401wt.eu-S1764398AbXEUXES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764398AbXEUXES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbXEUXED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:04:03 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41966 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757137AbXEUXEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:04:00 -0400
X-Sasl-enc: ShKORuq9IZP1cJVVkr/QfoZqUQIJ2Dv1fB79K8RlkuUm 1179788638
Date: Mon, 21 May 2007 20:03:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matt Mackall <mpm@selenic.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070521230349.GA645@khazad-dum.debian.net>
References: <20070519165738.GK11115@waste.org> <20070519204504.GA24704@khazad-dum.debian.net> <20070519223843.GN11115@waste.org> <20070520035259.GA13224@khazad-dum.debian.net> <20070521222339.GF11115@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521222339.GF11115@waste.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Matt Mackall wrote:
> BIOS Information
>         Vendor: IBM
>         Version: 1RETDHWW (3.13 )
>         Release Date: 10/29/2004
> 
> No sign of any EC version in the output.

This is a buggy, ancient version of the BIOS, which probably means you have
an old and slightly buggy EC firmware.  I recommend you to upgrade to BIOS
3.21 and EC 3.04.  See http://thinkwiki.org/wiki/BIOS_Upgrade for more
details.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
