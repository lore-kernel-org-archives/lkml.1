Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211AbZCXVjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbZCXVjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZCXVjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:39:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33033 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751706AbZCXVjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:39:18 -0400
Date: Tue, 24 Mar 2009 21:38:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrey Panin <pazke@donpac.ru>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 01/30] disallow SERIAL_8250_PNP with SERIAL_8250_CONSOLE
Message-ID: <20090324213841.59d6b299@lxorguk.ukuu.org.uk>
In-Reply-To: <20090324213416.GA29507@srcf.ucam.org>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
	<20090324140145.12735.29459.stgit@localhost.localdomain>
	<20090324151034.GC6859@ports.donpac.ru>
	<20090324152203.6a989d06@lxorguk.ukuu.org.uk>
	<20090324205945.GA28394@srcf.ucam.org>
	<20090324212653.77d6e70c@lxorguk.ukuu.org.uk>
	<20090324213416.GA29507@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Since the conversion to drivers/serial - so years.
> 
> So everyone using serial console with 8250_PNP enabled gets a crash on 
> boot, and has done for years? Really?

If their console port is PnP listed yes.

