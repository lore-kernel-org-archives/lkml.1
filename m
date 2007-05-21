Return-Path: <linux-kernel-owner+w=401wt.eu-S1765945AbXEUX0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765945AbXEUX0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762911AbXEUX00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:26:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761235AbXEUX0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:26:25 -0400
Date: Mon, 21 May 2007 19:25:07 -0400
From: Dave Jones <davej@redhat.com>
To: Uwe Bugla <uwe.bugla@gmx.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: Kernel Oops with 2.6.21.1 on an AMD K7 machine
Message-ID: <20070521232507.GB12157@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Uwe Bugla <uwe.bugla@gmx.de>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, torvalds@linux-foundation.org
References: <20070521222857.87180@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521222857.87180@gmx.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 12:28:57AM +0200, Uwe Bugla wrote:
 > Hello everybody,
 > 
 > kernel 2.6.21.1 makes my machine Oops about 20 seconds after KDE 3,5 is brought up showing its graphical login (kdm):
 > 
 > lspci -v, based on a "sane" kernel 2.6.22-rc2 or 2.6.20.11 (with both of them the Oops does not happen at all) looks like this:
 > 00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI Fast Ethernet (rev 90)

This is probably the sis900 oops that is fixed in 2.6.21.2rc1.

See http://lkml.org/lkml/2007/5/21/406

	Dave

-- 
http://www.codemonkey.org.uk
