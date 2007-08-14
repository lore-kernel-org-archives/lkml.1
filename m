Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbXHNLts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbXHNLts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758995AbXHNLtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:49:32 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:44027 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416AbXHNLta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:49:30 -0400
Date: Tue, 14 Aug 2007 13:49:31 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Paul Mackerras <paulus@samba.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070814114931.GA13319@aepfle.de>
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, Paul Mackerras wrote:

> David Woodhouse writes:
> 
> > There are proper device numbers registered for pmac_zilog now. Use them.

Which numbers?

> Sigh.  I guess this is inevitable, but IMNSHO this exposes a weakness
> in our serial subsystem.

So, when will the name of pmac_zilog get changed?
What major/minor pair will the two ports get?
