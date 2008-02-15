Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbYBOWNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbYBOWNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYBOWMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:12:51 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37957 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbYBOWMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:12:50 -0500
Date: Fri, 15 Feb 2008 16:12:37 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: becky.bruce@freescale.com, sparclinux@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4]: Respun LMB patches.
Message-ID: <20080215161237.4531e233@zod.rchland.ibm.com>
In-Reply-To: <20080214.141531.169094647.davem@davemloft.net>
References: <20080213.170938.34536425.davem@davemloft.net>
	<38133B3C-75A2-4465-9484-7BF8E7E85D1D@freescale.com>
	<20080214152448.49c69238@zod.rchland.ibm.com>
	<20080214.141531.169094647.davem@davemloft.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008 14:15:31 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> Date: Thu, 14 Feb 2008 15:24:48 -0600
> 
> > I plan on actually testing this on Ebony, Walnut, and Bamboo either
> > later tonight or tomorrow.  I don't expect many issues.
> > 
> > Dave, those above boards would cover the build of PowerPC 4xx CPU cores.
> 
> Ok.

Ok, booted just fine on Ebony (PowerPC 440), Bamboo(PowerPC 440 + FPU),
and Haleakala (PowerPC 405).

josh
