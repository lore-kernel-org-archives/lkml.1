Return-Path: <linux-kernel-owner+w=401wt.eu-S938751AbXG1Bh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938751AbXG1Bh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 21:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938425AbXG1BhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 21:37:17 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:5322 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938385AbXG1BhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 21:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LUu0Pdn7h6vRj7xEOpcKfBrIQaDNGfFuW6GtpqVe/SOprvnn+z0Z+pcVN61y9rrtmgwxsNZ3j3wfn2JoT8B/Wbsr93FL43c1DLUFO0Qd0v/BpPWcyc+b4ZRC73HyMDQf69OQ+cgh1bU79mJ4s12XgvjW0MVLOHS3UJDRLyfwWhQ=
Message-ID: <8bd0f97a0707271837q5d5f31d9pe342e72ebf9368c1@mail.gmail.com>
Date: Fri, 27 Jul 2007 21:37:14 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 06/68] 0 -> NULL, for arch/frv
Cc: "Yoann Padioleau" <padator@wanadoo.fr>,
       "David Howells" <dhowells@redhat.com>, kernel-janitors@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200707272138.23323.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707270944.LAA17167@ifs.emn.fr> <22618.1185531297@redhat.com>
	 <87lkd29mk9.fsf@wanadoo.fr>
	 <200707272138.23323.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> If there is a definite style or semantic preference that everyone should live
> with - does it make sense to put checks in checkpatch.pl to enforce it?

checkpatch.pl does not have enough semantic knowledge to know if the
thing being tested is a pointer ... dont know if the sparse utility
would be able to pick it out as i'm not familiar with what level that
thing runs at
-mike
