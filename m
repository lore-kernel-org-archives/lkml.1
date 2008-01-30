Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbYA3ItW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbYA3ItW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 03:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYA3ItB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 03:49:01 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33473 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbYA3Is7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 03:48:59 -0500
Message-ID: <47A039F7.7060204@garzik.org>
Date: Wed, 30 Jan 2008 03:48:55 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Tim Hockin <thockin@hockin.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] natsemi: Update locking documentation
References: <1201442291-13668-1-git-send-email-broonie@sirena.org.uk>
In-Reply-To: <1201442291-13668-1-git-send-email-broonie@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> The documentation regarding synchronisation at the head of the natsemi
> driver was badly bitrotted so replace it with a general statement about
> the techniques used which is less likely to bitrot.
> 
> Also remove the note saying these chips are uncommon - it makes little
> difference but they were used in a number of laptops and at least one mass
> market PCI ethernet card.
> 
> Signed-off-by: Mark Brown <broonie@sirena.org.uk>
> ---
>  drivers/net/natsemi.c |   18 ++----------------
>  1 files changed, 2 insertions(+), 16 deletions(-)

applied


