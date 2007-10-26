Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbXJZOqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbXJZOqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 10:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXJZOqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 10:46:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53578 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbXJZOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 10:46:19 -0400
Date: Fri, 26 Oct 2007 09:46:10 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rmk@arm.linux.org.uk, kernel@wantstofly.org, tony.luck@intel.com,
       benh@kernel.crashing.org, paulus@samba.org, dmitry.torokhov@gmail.com,
       netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-serial@vger.kernel.org, linux-wireless@vger.kernel.org,
       bryan.wu@analog.com, adaplas@gmail.com
Subject: Re: [PATCH] Remove pointless casts from void pointers,
Message-ID: <20071026094610.37defcb3@weaponx.rchland.ibm.com>
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; powerpc-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 05:40:22 -0400 (EDT)
Jeff Garzik <jeff@garzik.org> wrote:

> mostly in and around irq handlers.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---

>  drivers/serial/uartlite.c                  |    2 +-

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com
