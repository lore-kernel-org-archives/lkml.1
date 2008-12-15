Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbYLONDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbYLONDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 08:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYLONDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 08:03:00 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37156 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYLONC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 08:02:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=J2aeObW6Mx64Ztvqg+Xm0hLCvRT3hLNdE5l9tYQr47NSztJxthY0llrsvEicHxuMa8
         FwOdcB4st3zs6mSVaJNwAr/y2M4gGDhy1MpQyH+IQK2fzzuANVXFXTShg1Y4jH8RSyAo
         QdoiPY+ILJsN7lTzj7amISQdPhsIzipZTFYmo=
Message-ID: <7c86c4470812150502r7363dca2sdd869965febd7b73@mail.gmail.com>
Date: Mon, 15 Dec 2008 14:02:56 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vince Weaver" <vince@deater.net>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <18757.43477.613501.291292@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	 <1229073834.12883.41.camel@twins>
	 <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
	 <1229167048.13566.119.camel@twins>
	 <18756.23327.478759.5970@cargo.ozlabs.ibm.com>
	 <20081214223756.GA21808@elte.hu>
	 <18757.43477.613501.291292@drongo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 15, 2008 at 1:50 AM, Paul Mackerras <paulus@samba.org> wrote:

> FOSS is about freedom - we don't force anyone to use our code.  If
> someone wants to use their own code instead of glibc or libpfm on the
> user-space side of the syscall interface, that's fine.
>
Exactly right!

That was exactly my point when I said, you are free to not use libpfm
in your tool.
