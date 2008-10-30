Return-Path: <linux-kernel-owner+w=401wt.eu-S1755064AbYJ3Lim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064AbYJ3Lim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 07:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYJ3Lie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 07:38:34 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:49524 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbYJ3Lid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 07:38:33 -0400
Date: Thu, 30 Oct 2008 12:38:31 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: s390: struct device - replace bus_id with dev_name(),
	dev_set_name()
Message-ID: <20081030113831.GA3871@osiris.boeblingen.de.ibm.com>
References: <1225328227.5970.51.camel@nga.site> <20081030103200.438576a1@gondolin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030103200.438576a1@gondolin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:32:00AM +0100, Cornelia Huck wrote:
> On Thu, 30 Oct 2008 01:57:07 +0100,
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > From: Kay Sievers <kay.sievers@vrfy.org>
> > Subject: s390: struct device - replace bus_id with dev_name(), dev_set_name()
> > 
> > Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> 
> Other than the fact that this patch is a bit mis-named (it just gets
> rid of BUS_ID_SIZE), this looks fine to me.

Who is supposed to send this upstream and when?
