Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZHCV5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZHCV5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZHCV5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:57:51 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:54891 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbZHCV5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:57:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=imuBckrjdQblKJL9z17dy2i3wI/yKsYaLWRrGFIK9QaGJq4JJHYxnSr89LzV69sWmp
         65PPlOTv/NYYegueNqeLygJ7bX2ZAUZIkq43tw3ShuYfcNDmS9Ss80hxj8L1HKktF6sn
         62KMBoCPxBvEveoGgAtVjSRnaQcax6S/8wJS4=
Date: Tue, 4 Aug 2009 01:57:26 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org, Magnus Damm <damm@opensource.se>,
       akpm@linux-foundation.org, Matt Fleming <matt@console-pimps.org>,
       Philip Langdale <philipl@overt.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH] tmio_mmc: Optionally support using platform clock
Message-ID: <20090803215726.GA6450@doriath.ww600.siemens.net>
References: <Pine.LNX.4.64.0907280937000.4943@axis700.grange>
 <4A6F0123.9040809@mnementh.co.uk>
 <Pine.LNX.4.64.0907281556160.6219@axis700.grange>
 <4A6F30AF.4000004@mnementh.co.uk>
 <bc64b4640908010710w1a0d6344s3e810433c28aadd5@mail.gmail.com>
 <4A771EB2.70902@mnementh.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A771EB2.70902@mnementh.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 06:30:26PM +0100, Ian Molton wrote:
> Dmitry Eremin-Solenikov wrote:
> 
> >I don't think I'll have time to work on/refresh clocklib patches. Feel
> >free to continue
> >where I've left them.
> 
> Where is the latest version ?

Hmmm. I currently don't have access to the HDD I used at that moment.
Please use the lastes patches I've sent to LKML/LAKML. I'm sorry that
I'm not very helpful wrt these patches.

-- 
With best wishes
Dmitry

