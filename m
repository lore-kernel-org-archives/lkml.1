Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbXIIVDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbXIIVDn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbXIIVDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:03:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55406 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbXIIVDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:03:34 -0400
Date: Sun, 9 Sep 2007 23:03:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070909210329.GE25798@one.firstfloor.org>
References: <20070907124800.GP16806@vanheusden.com> <p73fy1p9m57.fsf@bingen.suse.de> <1189371621.3526.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189371621.3526.28.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I can see where you're coming from, but logically, this is wrong.
> There's a huge slew of enterprise machines that only have DVD on SATA.

... and enterprise systems don't really care about a few KB more of code.
In fact you definitely want to have SATA compiled in in case you need
to recover the machine later when the SAN is down.

> On the other hand, all of these machines will have SCSI disk devices on
> various other transports, so no harm is done, it's just an inelegant
> solution.

Do you know of a better one?

-Andi
