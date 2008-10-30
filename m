Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYJ3JcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYJ3JcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 05:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYJ3JcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 05:32:08 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:57393 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYJ3JcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 05:32:05 -0400
Date: Thu, 30 Oct 2008 10:32:00 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: s390: struct device - replace bus_id with dev_name(),
 dev_set_name()
Message-ID: <20081030103200.438576a1@gondolin>
In-Reply-To: <1225328227.5970.51.camel@nga.site>
References: <1225328227.5970.51.camel@nga.site>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 01:57:07 +0100,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: s390: struct device - replace bus_id with dev_name(), dev_set_name()
> 
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>

Other than the fact that this patch is a bit mis-named (it just gets
rid of BUS_ID_SIZE), this looks fine to me.
