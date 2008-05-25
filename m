Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbYEYSDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbYEYSDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbYEYSDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:03:42 -0400
Received: from mail.scaimas.com ([195.82.67.50]:19420 "EHLO mail.scaimas.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbYEYSDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:03:42 -0400
Subject: RE: Limit SATA link speed to 1.5 Gbps-
Date: Sun, 25 May 2008 20:03:40 +0200
Message-ID: <F7D77F204D5F7641AB3864C88E39498F18615B@taube3.scailokal.intern>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Limit SATA link speed to 1.5 Gbps-
Thread-Index: Aci8AOthirlgG+LLTb2/xStWyNZ5DwCkT4CA
References: <F7D77F204D5F7641AB3864C88E39498F18614E@taube3.scailokal.intern> <20080522122905.49cca18d@core>
From: "Andre Pietsch" <andre.pietsch@scai.de>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
content-class: urn:content-classes:message
Cc: <linux-kernel@vger.kernel.org>
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan & others,

> > Is it possible to set the SATA link speed somewhere?
> 
> Not sure. I've not looked whether that is in the new "force" 
> code. I don't think you can in 2.6.24 however, and 2.6.25 
> will fall back nicely.
> 
> Other than being annoying during the install it should not 
> cause any other problems beyond all the retries.
> 
SOLVED
On Seagate drives it is possible to limit the link speed by setting a
jumper on the drive! It now starts at 1.5 Gbps and runs stable from the
start.

Thanks everybody for your support!

Regards,
Andre Pietsch

