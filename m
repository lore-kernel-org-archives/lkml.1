Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab0BCH14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 02:27:56 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:52696 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0BCH1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 02:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=KGwuT+RJQx6cGlHAgbFyR/cVGbSLHEq2u04P7TdCUrpiPBpTOt0eJklf7uTSsqvW2a
         rJEdk7ChJc63l0L6cub1JhJngyo2sbC95fD3jgweOPKWFQODqUxDOL9SzECbUuWdADVV
         xp7QIPq9RbJ4M40LGyj8IWmDB0nDRElICqS/Y=
Date: Wed, 3 Feb 2010 08:27:47 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: Joe Perches <joe@perches.com>
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scripts/get_maintainer.pl: add ability to read from
 STDIN
Message-ID: <20100203072747.GB5428@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Joe Perches <joe@perches.com>, Daniel Mack <daniel@caiaq.de>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1265135412-18391-1-git-send-email-daniel@caiaq.de>
 <1265175347.18067.5.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1265175347.18067.5.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 09:35:47PM -0800, Joe Perches wrote:
> On Wed, 2010-02-03 at 02:30 +0800, Daniel Mack wrote:
> > This is useful for finding people for the Cc: list without dumping the
> > patch to a file before.
> 
> Hi Daniel.
> 
> I think it's better if the dash isn't required.
> I like this patch which is based on your idea.
> 
> http://patchwork.kernel.org/patch/69650/

Yeah, about that, when are you going to send it upstream? Or do you want
me to do that?

-- 
Regards/Gruss,
    Boris.
