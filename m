Return-Path: <linux-kernel-owner+w=401wt.eu-S1761929AbXGXQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761929AbXGXQ7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXGXQ7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:59:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:61365 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbXGXQ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PximkjPAtpEzSxhBLCp0vVojflJ8yLC49YqepwJEbZ4Dg7/ZNlwPnitXJEmlpgZiEXSZJ2LHFmLHs0DKsU8S9EHdKiunvRuYUEwhSsQ5I5gAB3pfe7uuM/IBS1kKCIJ1ECVXuYLena+f9SbftyRnPHWBvpxNM5AJgWJ5Cuz4+UI=
Message-ID: <9a8748490707240959n69154cccna58e8ae0f1788ea@mail.gmail.com>
Date: Tue, 24 Jul 2007 18:59:02 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: [PATCH][30/37] Clean up duplicate includes in net/netfilter/
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       "David S Miller" <davem@davemloft.net>,
       "Harald Welte" <laforge@netfilter.org>,
       netfilter-devel@lists.netfilter.org,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "James Morris" <jmorris@redhat.com>,
       "Netfilter Core Team" <coreteam@netfilter.org>,
       "Bart De Schuymer" <bdschuym@pandora.be>
In-Reply-To: <46A61B32.90302@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707211703.47827.jesper.juhl@gmail.com>
	 <46A61B32.90302@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/07/07, Patrick McHardy <kaber@trash.net> wrote:
> Jesper Juhl wrote:
> > This patch cleans up duplicate includes in
> >       net/netfilter/
>
>
> I've queued this one and the bridge-netfilter patch (27/37), thanks
> Jesper.
>
Thanks for the feedback Patrick.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
