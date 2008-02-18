Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbYBRNEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbYBRNEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761084AbYBRNC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:02:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761069AbYBRNC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:02:56 -0500
Date: Mon, 18 Feb 2008 05:01:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Dominik Brodowski <linux@brodo.de>, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] the long overdue pcmcia_ioctl.c removal
Message-Id: <20080218050133.23454db1.akpm@linux-foundation.org>
In-Reply-To: <20080213213115.GW3383@cs181133002.pp.htv.fi>
References: <20080213213115.GW3383@cs181133002.pp.htv.fi>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 23:31:15 +0200 Adrian Bunk <bunk@kernel.org> wrote:

> pcmcia_ioctl.c was scheduled for removal in 2005, and it has a 
> deprecation printk() since 2005 (sic).
> 
> This patch contains the long overdue removal and the cleanups that are 
> now possible.

I've had this in -mm for ages, with a note that Dominik had a problem with
it.  Maybe there are subtleties here, dunno.

