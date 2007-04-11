Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbXDKPjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbXDKPjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 11:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbXDKPjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 11:39:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbXDKPjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 11:39:04 -0400
Date: Wed, 11 Apr 2007 11:38:57 -0400
From: Alan Cox <alan@redhat.com>
To: Milind Arun Choudhary <milindchoudhary@gmail.com>
Cc: kernel-janitors@lists.osdl.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alan@redhat.com
Subject: Re: [KJ][PATCH] SPIN_LOCK_UNLOCKED cleanup in drivers/ata/pata_winbond.c
Message-ID: <20070411153857.GA19968@devserv.devel.redhat.com>
References: <20070411152846.GA11449@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411152846.GA11449@arun.site>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 08:58:46PM +0530, Milind Arun Choudhary wrote:
> remove SPIN_LOCK_UNLOCKED, use DEFINE_SPINLOCK instead
> 
> Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

Acked-by: Alan Cox <alan@redhat.com>
