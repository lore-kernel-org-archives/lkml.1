Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbYIAJjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbYIAJjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbYIAJiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:38:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57404 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYIAJiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:38:50 -0400
Date: Mon, 1 Sep 2008 10:37:56 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Elias Oltmanns <eo@nebensachen.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
Message-ID: <20080901093756.GA13080@srcf.ucam.org>
References: <87wshzplvk.fsf@denkblock.local> <87ej45mlp3.fsf@denkblock.local> <48BA969C.4060207@gmail.com> <200808311632.04584.bzolnier@gmail.com> <87wshxkt9c.fsf@denkblock.local> <20080901020821.GA12532@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901020821.GA12532@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2008 at 11:08:21PM -0300, Henrique de Moraes Holschuh wrote:
> On Sun, 31 Aug 2008, Elias Oltmanns wrote:
> > Admittedly, I don't know very much about it myself but I seem to
> > remember that there are other vendors now shipping similar technology.
> 
> Apple, HP.

HP typically put the CD drive and hard drive on the same channel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
