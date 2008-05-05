Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYEEMaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYEEMaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYEEMaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:30:04 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:42999 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYEEMaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:30:01 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: s390 kvm_virtio.c build error
Date: Mon, 5 May 2008 14:29:47 +0200
User-Agent: KMail/1.9.9
Cc: Adrian Bunk <bunk@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>, Avi Kivity <avi@qumranet.com>,
       Rusty Russell <rusty@rustcorp.com.au>, kvm-devel@lists.sourceforge.net,
       linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080503174716.GM5838@cs181133002.pp.htv.fi> <20080504192537.GA5499@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20080504192537.GA5499@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051429.47446.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm... this should help:
> 
> ---
>  drivers/s390/kvm/kvm_virtio.c |   40 
+++++++++++++++++++++++-----------------
>  1 file changed, 23 insertions(+), 17 deletions(-)

Thanks Heiko.
I did a short test and it seems to work.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

This looks almost identical to Rusty's patch. Who is going to send this (or 
Rustys) patch to Linus?

Christian
