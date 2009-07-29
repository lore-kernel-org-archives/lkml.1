Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZG2AdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZG2AdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 20:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZG2AdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 20:33:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49844 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZG2AdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 20:33:24 -0400
Date: Wed, 29 Jul 2009 02:33:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mce: don't log boot MCEs on Pentium M (model == 13)
	CPUs
Message-ID: <20090729003324.GA27146@basil.fritz.box>
References: <200907282352.55047.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907282352.55047.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 11:52:54PM +0200, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] mce: don't log boot MCEs on Pentium M (model == 13) CPUs
> 
> On my legacy Pentium M laptop (Acer Extensa 2900) I get bogus MCE on a cold
> boot with CONFIG_X86_NEW_MCE enabled, i.e. (after decoding it with mcelog):

Thanks, Bart. All four patches look good.

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
