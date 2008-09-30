Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbYI3VHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbYI3VHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYI3VHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:07:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:9259 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbYI3VHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=E276ysJTOTM5WHN/PK7sgs2ULLmgwiO8OAo5scN5lCCkbytS1bAsyAvxedPAbMx35W
         ITkMbkRCIyT1mZhZAf5FelwcXPAOpcQEOcIX8dg+O+ojA2uvYYPjQoSb+RLAz5e5NuHz
         hcGNGkq0m/7eejcXXUPbn02jFymH25Ytx9ZG0=
Date: Tue, 30 Sep 2008 23:06:44 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alessandro Rubini <ar@gnudd.com>,
       Alessandro Rubini <rubini@vision.unipv.it>
Subject: Re: About the maintainer of "MOUSE AND MISC DEVICES"
Message-Id: <20080930230644.107e6428.kristoffer.ericson@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0809302248150.2307@twin.jikos.cz>
References: <20080930153708.GX18732@tekkaman>
	<Pine.LNX.4.64.0809302248150.2307@twin.jikos.cz>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 22:55:40 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 30 Sep 2008, Rodolfo Giometti wrote:
> 
> > I just wrote to Alessandro in order to have some suggestions about a 
> > misc device I wish to propose to this list, but he told me that he wants 
> > leave his maintanership.
> > So which is the person should I send my requests about misc devices?
> > He also asked to me to propose to this list a "patch" to remove him
> > from the MAINTANERS file... if so the new entry should be:
> > MOUSE AND MISC DEVICES [GENERAL]
> > L:      linux-kernel@vger.kernel.org
> > S:      Maintained
> 
> I in fact never understood what this maintainers entry meant ... what is 
> the device in question here?

I thought mouse was a part of linux-input? Or am I missing something?
Besides that misc thingie is really creepy, makes me feel Ive
missed something.

> 
> Anyway, something for Andrew
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] remove "Mouse and Misc devices" from MAINTAINERS
> 
> remove "Mouse and Misc devices" from MAINTAINERS
> 
> Alessandro himself claims that he gives up maintainership, and to be 
> frank, I don't have a clue what this entry is about.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 
> --- 
> 
>  MAINTAINERS |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3596d17..3d9635f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2818,12 +2818,6 @@ M:	ppisa@pikron.com
>  L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
>  S:	Maintained
>  
> -MOUSE AND MISC DEVICES [GENERAL]
> -P:	Alessandro Rubini
> -M:	rubini@ipvvis.unipv.it
> -L:	linux-kernel@vger.kernel.org
> -S:	Maintained
> -
>  MOXA SMARTIO/INDUSTIO/INTELLIO SERIAL CARD
>  P:	Jiri Slaby
>  M:	jirislaby@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>
