Return-Path: <linux-kernel-owner+w=401wt.eu-S1764963AbXGJStt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764963AbXGJStt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbXGJStj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:49:39 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41432 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757486AbXGJSti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:49:38 -0400
Date: Tue, 10 Jul 2007 13:49:36 -0500
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] [ide] mmio ide support
Message-ID: <20070710184936.GF24480@austin.ibm.com>
References: <20070707094852.9473.21013.stgit@localhost.localdomain> <468FC4AC.9030701@ru.mvista.com> <200707072007.10448.arnd@arndb.de> <200707081515.42105.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707081515.42105.bzolnier@gmail.com>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2007 at 03:15:41PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> > on the argument that drivers/ide/ is going away soon. Most
> > current distros have already moved over to using libata
> > exclusively.
> 
> The in-kernel default for PATA systems is still IDE subsystem.

In part because libata still does not yet work correctly 
for at least some (older) ide chipsets (like mine).

--linas
