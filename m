Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbZFXVUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbZFXVUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZFXVTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:19:55 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:65058 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZFXVTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:19:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m6dGDJQpjTF8uDk8ViI89Av4LEUuVbUpk1uu8ok0lYAdVOzq0soUEaBZRzICSsY3PW
         E8Rc5dDTW2R/jTTWQG5A4QMt0v6IDzD3EGOqQvhaJ4DHsi0wcu+GZlDELppBCgDf3pfY
         dn22vTeJTTO4sqL0yX+eAlKhY8M8ql4i/VLl4=
MIME-Version: 1.0
In-Reply-To: <20090624175940.GC7576@elte.hu>
References: <4A3FB09D.9050903@gmail.com> <20090622153431.GA18466@elte.hu>
	 <25e057c00906220847t15425f38maf486c291d1d2468@mail.gmail.com>
	 <4A3FB479.2090902@lsrfire.ath.cx>
	 <7vhby64i8f.fsf@alter.siamese.dyndns.org>
	 <20090624081819.GA10436@elte.hu>
	 <alpine.DEB.1.00.0906241201040.4773@pacific.mpi-cbg.de>
	 <7vws71wquf.fsf@alter.siamese.dyndns.org>
	 <alpine.DEB.1.00.0906241835240.7946@intel-tinevez-2-302>
	 <20090624175940.GC7576@elte.hu>
Date: Wed, 24 Jun 2009 23:19:54 +0200
Message-ID: <81b0412b0906241419q3bdef822laf9a879ce790d8f@mail.gmail.com>
Subject: Re: [PATCH] fread does not return negative on error
From: Alex Riesen <raa.lkml@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Schindelin <Johannes.Schindelin@gmx.de>,
       Junio C Hamano <gitster@pobox.com>,
       =?UTF-8?Q?Ren=C3=A9_Scharfe?= <rene.scharfe@lsrfire.ath.cx>,
       roel kluin <roel.kluin@gmail.com>, git@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/24 Ingo Molnar <mingo@elte.hu>:
> +Here is an (incomplete!) list of main contributors to those files
> +in util/* and elsewhere:
> +
> + Alex Riesen

Wow. But I actually think it may be more fair to sort the list after
any kind of rating (even something as dumb as commit count).

As everyone one the list knows, I am nowhere near a "major contributor"
to the project, as the first place may imply to a casual reader.
