Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZAGOCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZAGOCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 09:02:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbZAGOBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 09:01:51 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:61622 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbZAGOBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 09:01:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cUQWC0jU+5l0GDobCTC+BCxavvtegEUwD+kfK17IGtQpXkXTqyrSkZuUtUh+09GL4t
         VfALwofpYO8EDAMdRzAM5rG5vfjI3w5idmur47R7xJxTCAdz8nmW18VtG6Ibv7k3G8BT
         WfNW0piPjVZ0P1FbFMoBGL9QoTKapUMG7H4W4=
Date: Wed, 7 Jan 2009 14:01:41 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Data corruption issue with splice() on 2.6.27.10
Message-ID: <20090107140141.GF9677@ff.dom.local>
References: <20090107122238.GB25673@gondor.apana.org.au> <20090107123741.GA31255@ioremap.net> <20090107124246.GA26034@gondor.apana.org.au> <20090107124629.GA31732@ioremap.net> <20090107125535.GC6307@1wt.eu> <20090107125734.GA26331@gondor.apana.org.au> <20090107130259.GB32336@ioremap.net> <20090107131057.GD9677@ff.dom.local> <20090107131539.GF6307@1wt.eu> <20090107132258.GE9677@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107132258.GE9677@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 01:22:58PM +0000, Jarek Poplawski wrote:
...
> Sure! Congratulations for debugging to you and Evgeniy!

...and Herbert! (I missed the beginning of this GSO trail...)

Jarek P.
