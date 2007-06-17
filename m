Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXFQPrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXFQPrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 11:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbXFQPrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 11:47:06 -0400
Received: from nn7.de ([85.214.94.156]:33636 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbXFQPrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 11:47:06 -0400
Subject: Re: git-current: slub breaks s2ram with fglrx...
From: Soeren Sonnenburg <kernel@nn7.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Stefan Seyfried <seife@suse.de>, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <6bffcb0e0706170833x36aa33a3x5ff81ba5a112528f@mail.gmail.com>
References: <1182073786.3841.11.camel@localhost>
	 <200706171304.46181.rjw@sisk.pl> <1182093905.3841.23.camel@localhost>
	 <6bffcb0e0706170833x36aa33a3x5ff81ba5a112528f@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 17 Jun 2007 17:47:03 +0200
Message-Id: <1182095223.3841.28.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 17:33 +0200, Michal Piotrowski wrote:
> Hi Soeren,

Hi Michael,

[...]
> > I have one question: What if I don't load fglrx.ko but still use the
> > proprietary binary driver for xorg.
> 
> AFAIK it will not work.

well I *know* that X works without fglrx loaded (no 3d acceleration/ no
xv extensions though). I would be happily using the no-fglrx setup if
s2ram worked (and is more stable than with fglrx loaded). But currently
it just reboots on resume, so ...

> Shouldn't s2ram work with that ? And
> if not is this considered a kernel bug or still a ati-binary driver
> bug ?

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
