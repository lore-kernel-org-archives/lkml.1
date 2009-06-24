Return-Path: <linux-kernel-owner+w=401wt.eu-S1754365AbZFXI1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbZFXI1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbZFXI1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:27:17 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44557 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZFXI1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:27:16 -0400
Subject: Re: BUS_ID_SIZE is going away
From: Kay Sievers <kay.sievers@vrfy.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Takashi Iwai <tiwai@suse.de>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1245675383.25547.50.camel@macbook.infradead.org>
References: <1245527124.30962.14.camel@yio.site>
	 <1245675383.25547.50.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Wed, 24 Jun 2009 10:27:18 +0200
Message-Id: <1245832038.2483.3.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 13:56 +0100, David Woodhouse wrote:
> I have this queued for 2.6.31 but have been on jury duty for the last 2
> weeks so I'm hoping to get the pull request to Linus today now that I'm
> free.

The old one is gone, but seems you merged a new one with BUS_ID_SIZE :)

  ./drivers/mtd/maps/integrator-flash.c:#define SUBDEV_NAME_SIZE	(BUS_ID_SIZE + 2)

Thanks,
Kay

