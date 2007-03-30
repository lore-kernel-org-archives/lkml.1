Return-Path: <linux-kernel-owner+w=401wt.eu-S1750943AbXC3RWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943AbXC3RWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 13:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXC3RWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 13:22:34 -0400
Received: from mx.laposte.net ([81.255.54.16]:49198 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbXC3RWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 13:22:34 -0400
Subject: Re: [PATCH 1/5] RT kernel: force detect HPET from PCI space
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070330165949.GA19584@linux-os.sc.intel.com>
References: <1175273420.23240.3.camel@rousalka.dyndns.org>
	 <20070330165949.GA19584@linux-os.sc.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Organization: Adresse perso
Date: Fri, 30 Mar 2007 19:22:28 +0200
Message-Id: <1175275348.24045.1.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-5.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 30 mars 2007 à 09:59 -0700, Venki Pallipadi a écrit :
> On Fri, Mar 30, 2007 at 06:50:19PM +0200, Nicolas Mailhot wrote:
> > Anyone got the same thing for CK804? I had my hopes high, and then I saw
> > the DECLARE_PCI_FIXUP_HEADER values [and the thread title was
> > misleading]
> > 
> 
> Sorry about the wrong subject. It should have had ICH in the subject somewhere.

I think I'll recover :)

> On the brighter side, if you find the chipset document for your chipset,
> It should be as easy as this patch to force enable it :-).

It's only at the rainbow end, right?

-- 
Nicolas Mailhot
