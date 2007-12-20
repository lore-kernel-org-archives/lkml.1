Return-Path: <linux-kernel-owner+w=401wt.eu-S934622AbXLTQCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934622AbXLTQCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:02:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbXLTQBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:01:50 -0500
Received: from mail.queued.net ([207.210.101.209]:2211 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933023AbXLTQBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:01:48 -0500
Date: Thu, 20 Dec 2007 11:00:30 -0500
From: Andres Salomon <dilinger@queued.net>
To: cbou@mail.ru
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071220110030.1e20ad51@ephemeral>
In-Reply-To: <20071220150716.GA31896@localhost.localdomain>
References: <20071216212443.4a1fff3d@ephemeral>
	<1197858984.3798.201.camel@shinybook.infradead.org>
	<20071217055123.GA2274@zarina>
	<20071217024139.2f81e36d@ephemeral>
	<20071217112416.GA25948@localhost.localdomain>
	<20071218021001.46783004@ephemeral>
	<20071219123546.GA6277@localhost.localdomain>
	<20071219130241.21f0b416@ephemeral>
	<20071219185050.GA1570@localhost.localdomain>
	<20071219181304.48609ecb@ephemeral>
	<20071220150716.GA31896@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 18:07:16 +0300
Anton Vorontsov <cbou@mail.ru> wrote:

> Hi Andres,
> 
[...]
> 
> Then, what the power supply subsystem is for? Just place all the
> drivers together in driver/power/, and let them create sysfs
> attributes by their own. You'll get a medley, not the subsystem.
> 
> Good luck,
> 


Ok, I'm really tired of arguing about this.  I've pointed out why
the current API is inadequate, but you seem to be resisting
changing it.  It's your subsystem, do what you like.

