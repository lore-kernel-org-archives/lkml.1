Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbXLUB0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbXLUB0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 20:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbXLUB01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 20:26:27 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:57916 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbXLUB00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 20:26:26 -0500
Date: Thu, 20 Dec 2007 19:20:47 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [RFC] [PATCH 2/3] Rework arch specific Makefiles to use mkimage
Message-ID: <20071220192047.5c58f739@zod.rchland.ibm.com>
In-Reply-To: <8bd0f97a0712201702y3621f60cvf165e41f61ed913c@mail.gmail.com>
References: <20071220101643.48b427ef@zod.rchland.ibm.com>
	<20071220101829.44ca59da@zod.rchland.ibm.com>
	<8bd0f97a0712201702y3621f60cvf165e41f61ed913c@mail.gmail.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 20:02:30 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> On Dec 20, 2007 11:18 AM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> > Rework the architecture specific Makefiles to use the in-kernel version
> > of the mkimage tool.
> >
> > Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> >
> >  arch/blackfin/boot/Makefile     |    4 ++--
> 
> we dont particularlly care one way or the other as it really makes no
> difference to us :)

Ok, good to know.  Thanks :)

josh
