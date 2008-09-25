Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYIYG4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYIYG4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYIYG4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:56:08 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:39784 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbYIYG4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:56:06 -0400
Date: Thu, 25 Sep 2008 08:55:56 +0200
From: Sebastien Dugue <sebastien.dugue@bull.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, torvalds@gtf.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Klein <osstklei@de.ibm.com>
Subject: Re: [git patches] net driver updates for .28
Message-ID: <20080925085556.4c430028@bull.net>
In-Reply-To: <20080924230710.GA22856@havoc.gtf.org>
References: <20080924230710.GA22856@havoc.gtf.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi Jeff,

On Wed, 24 Sep 2008 19:07:10 -0400 Jeff Garzik <jeff@garzik.org> wrote:


> Sebastien Dugue (2):
>       ehea: fix phyp debugging typo


>       ehea: fix mutex and spinlock use

        ^^^^^^

  That last one was NACKed by Thomas Klein (http://lkml.org/lkml/2008/9/15/81)
who asked for it to be reverted.

  Thanks,

  Sebastien.
