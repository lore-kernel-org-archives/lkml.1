Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZDXKa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZDXKa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZDXKat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:30:49 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40840 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbZDXKas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:30:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=efjFV68XDb2Qdo4mNcpZlN4wz76JIxSfqTvxDY9E7Nhrivklx6s7p7XJQ0jzG/2ioj
         McNW1A49kK8nzuGr40tBf4+Ux/S6YCOBaRKxlpHH0Ij/m/LCvaDr5ox+Vm/G35j6YzLV
         mx65IaOHzXE1QzGpR7C6RyJPA4ydJHze8rZbo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] MAINTAINERS: update IDE entry
Date: Fri, 24 Apr 2009 11:54:04 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200904232248.31735.bzolnier@gmail.com> <49F17390.7070003@ru.mvista.com>
In-Reply-To: <49F17390.7070003@ru.mvista.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904241154.04860.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 April 2009 10:08:48 Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > By a popular demand quilt tree was replaced by a git one.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  MAINTAINERS |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: b/MAINTAINERS
> > ===================================================================
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2743,7 +2743,7 @@ IDE SUBSYSTEM
> >  P:	Bartlomiej Zolnierkiewicz
> >  M:	bzolnier@gmail.com
> >  L:	linux-ide@vger.kernel.org
> > -T:	quilt kernel.org/pub/linux/kernel/people/bart/pata-2.6/
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6.git
> >   
> 
>   Does that mean that the patches that have been already accepeted into 
> the git tree, can't be updated afterwards (i.e. I have a habit of 
> sometimes sending several takes of the same patch)?

Yes, please just send incremental updates once the patch has been merged.

Thanks,
Bart
