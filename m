Return-Path: <linux-kernel-owner+w=401wt.eu-S1762622AbYEARFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622AbYEARFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 13:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757183AbYEAREu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 13:04:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:49265 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbYEAREt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 13:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=c7JiGXlefwbOPoIYBDucljdKL3TyPTEkbkpIsqUJb6rgpqmf+4kA8gxZBIhP7z8UtoQwiSqGfHLquQxYPO8nvj9PI315eb2NJzkbnry7XvMOvV444U5ARKNtAdNkoe1nLb0lhy8VGXUOM9vTBXaKqGKoRPDYxmRz4vE1g7FGsjg=
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Subject: Re: This month's price for the most useless new Kconfig help text ...
Date: Thu, 1 May 2008 20:04:42 +0300
User-Agent: KMail/1.9.9
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
References: <20080501120959.GA16700@basil.nowhere.org> <20080501154720.GA3476@infradead.org> <20080501160129.GU4797@implementation.uk.xensource.com>
In-Reply-To: <20080501160129.GU4797@implementation.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805012004.42706.maximlevitsky@gmail.com>
From: Maxim Levitsky <nadejdalevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 1 May 2008 19:01:29 Samuel Thibault wrote:
> Christoph Hellwig, le Thu 01 May 2008 11:47:20 -0400, a écrit :
> > On Thu, May 01, 2008 at 02:19:00PM +0100, Samuel Thibault wrote:
> > > If the society was a bit more aware of accessibility troubles in general
> > > (I mean in the street etc.), we wouldn't have to explain the word
> > 
> > Blah, an agenda is not an excuse for bad option descriptions.
> 
> Sure, that's why I provided a patch :)
> 
> (I agree that Kconfig helps like "CONFIG_FUSION: Say Y here to get to
> see options for Fusion Message Passing Technology (MPT) drivers" do not
> help much, I just didn't know that people were now actually caring about
> having some real explanations beyond the usual "if you don't know what
> it is, you don't need it, just say no")
Speaking of which I remember how I was confused when I found out that this driver 
is the linux driver for "SCI logic" SCSI vmware adapter :-)

> 
> > And btw, the word accessibility in the sense used here doesn't translate
> > at all into many foreign languages,
> 
> Right.
> 
> Samuel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Regards,
	Maxim Levitsky
