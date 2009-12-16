Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbZLPRa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbZLPRa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762549AbZLPRaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:30:55 -0500
Received: from defer-dn03.ocn.ad.jp ([125.170.100.156]:46601 "EHLO
	defer-dn03.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762492AbZLPRaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:30:55 -0500
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Dec 2009 12:30:55 EST
Date: Thu, 17 Dec 2009 02:04:21 +0900 (JST)
Message-Id: <20091217.020421.229277514.anemo@mba.ocn.ne.jp>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] spi_txx9.c: use resource_size()
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200EA8F@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090200EA8F@mi8nycmail19.Mi8.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 17:43:42 -0500, "H Hartley Sweeten" <hartleys@visionengravers.com> wrote:
> Use resource_size().
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Thanks,

Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
