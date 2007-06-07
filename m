Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbXFGLwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbXFGLwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 07:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXFGLwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 07:52:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:65448 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXFGLwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 07:52:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qUoZ7DExzckwM6PY1LURKG6Mu1fnc9mlZ3W2S3T/pbUhSjdhPrYpcURofPePfe3Lx+gpWbGTR0tT4h6ZnS2SIaA+4aE/vOLeomh4MScpw7Esb64WLl6xL9qHVOSWx0YQaBvdh0hcFTiUs2a0Ek/l+8Ga4re7w++gV+OgdBrfKNc=
Message-ID: <9a8748490706070452l4e4965b0r2ff6999bac10e237@mail.gmail.com>
Date: Thu, 7 Jun 2007 13:52:35 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Cc: "Andrew Morton" <akpm@osdl.org>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4667F00A.106@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
	 <9a8748490706060449s1df41fd5qbd77f6fa07289eaa@mail.gmail.com>
	 <4667F00A.106@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/07, Andy Whitcroft <apw@shadowen.org> wrote:
> Jesper Juhl wrote:
> > On 04/06/07, Andy Whitcroft <apw@shadowen.org> wrote:
> >>
> >> This version brings a host of changes to cure false positives and
> >> bugs detected on patches submitted to lkml and -mm.  It also brings
> >> a number of new tests in response to reviews, of particular note:
> >>
> > A  chmod +x scripts/checkpatch.pl  would be nice :)
>
> While git carries the permissions I am am pretty sure a straight patch
> doesn't.  Where did you pick up your copy from linus' tree or from the
> -mm one?
>
via 'git pull' from Linus' tree.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
