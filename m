Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbXI1J5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbXI1J5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbXI1J5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:57:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49636 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776AbXI1J52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:57:28 -0400
Date: Fri, 28 Sep 2007 02:56:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Jeff Garzik <jgarzik@pobox.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, michal.k.k.piotrowski@gmail.com,
       bryan@arbores.ca, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata drain fifo on stuck DRQ HSM violation
Message-Id: <20070928025644.7ee4af0c.akpm@linux-foundation.org>
In-Reply-To: <46FCCDEC.20200@gmail.com>
References: <46CFA08E.6090604@arbores.ca>
	<6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com>
	<46DBCB6C.8080206@gmail.com>
	<20070905095327.6277d054.akpm@linux-foundation.org>
	<46DEE617.4050004@rtr.ca>
	<46E0A253.7060803@gmail.com>
	<46E154DE.2060602@rtr.ca>
	<46FB563A.80108@gmail.com>
	<20070927193701.6230d77f@the-village.bc.nu>
	<46FC3D7D.90009@gmail.com>
	<46FC3FDD.5060201@pobox.com>
	<46FC423C.2050206@gmail.com>
	<46FC7B72.2030103@rtr.ca>
	<46FCCDEC.20200@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 02:48:28 -0700 Tejun Heo <htejun@gmail.com> wrote:

> Mark Lord wrote:
> > Drain up to 512 words from host/bridge FIFO on stuck DRQ HSM violation,
> > rather than just getting stuck there forever.
> > 
> > Signed-Off-By:  Mark Lord <mlord@pobox.com>
> 
> Acked-by: Tejun Heo <htejun@gmail.com>
> 

Nacked-by: scripts/checkpatch.pl
