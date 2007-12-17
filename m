Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbXLQX5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbXLQX5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 18:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760461AbXLQX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 18:57:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:51869 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbXLQX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:57:22 -0500
Subject: Re: [RFC/PATCH 1/4] pci: Add pci_enable_device_{io,mem} intefaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Johannes Weiner <hannes@saeurebad.de>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, wingel@nano-system.com,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, james.smart@emulex.com,
       linux-driver@qlogic.com, linux-kernel@vger.kernel.org
In-Reply-To: <x7prx4vq3e.fsf@saeurebad.de>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <x7prx4vq3e.fsf@saeurebad.de>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 10:55:36 +1100
Message-Id: <1197935736.13400.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-18 at 00:49 +0100, Johannes Weiner wrote:
> 
> These two functions should be refactored, the only difference is the
> flag checking.

Yeah, I somewhat though about it... anyway, it's not important right
now, I'm waiting for feedback on the approach itself. I'll send a new
patch with a nicer implementation later.

Cheers,
Ben.


