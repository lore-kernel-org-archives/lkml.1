Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYDXKIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYDXKIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 06:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYDXKHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 06:07:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38931 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751140AbYDXKHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 06:07:53 -0400
Date: Wed, 23 Apr 2008 19:22:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Tejun Heo <htejun@gmail.com>, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove ata_cable_sata()
Message-ID: <20080423192243.1f117215@the-village.bc.nu>
In-Reply-To: <20080421085131.GE26897@cs181133002.pp.htv.fi>
References: <20080421085131.GE26897@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Apr 2008 11:51:31 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch removes the no longer used ata_cable_sata()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

NAK - this one is a sensible part of the driver API
