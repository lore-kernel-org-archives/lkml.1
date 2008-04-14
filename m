Return-Path: <linux-kernel-owner+w=401wt.eu-S1761227AbYDNUuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227AbYDNUuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYDNUuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:50:44 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:11934 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbYDNUun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:50:43 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [2.6 patch] drivers/pnp/manager.c cleanups
Date: Mon, 14 Apr 2008 14:50:27 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <bunk@kernel.org>, ambx1@neo.rr.com,
       linux-kernel@vger.kernel.org
References: <20080414184038.GB6695@cs181133002.pp.htv.fi> <4803B6C6.2020608@keyaccess.nl>
In-Reply-To: <4803B6C6.2020608@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141450.27805.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008 01:55:50 pm Rene Herman wrote:
> On 14-04-08 20:40, Adrian Bunk wrote:
> 
> > This patch contains the following cleanups that are now possible:
> > - remove the following unused functions:
> >   - pnp_manual_config_dev()
> >   - pnp_resource_change()
> > - remove the following unused EXPORT_SYMBOL's:
> >   - pnp_start_dev
> >   - pnp_stop_dev
> >   - pnp_init_resource_table
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Bjorn Helgaas (added to CC) is busy here, including doing the above. Don't 
> know if he minds this not going through his own set...

I've recently posted patches that include the above.  The easiest for
me would be to just wait for mine to avoid having to resolve more
conflicts.

I'm in the middle of updating my series and hope to post a new version
later this week.

Bjorn
