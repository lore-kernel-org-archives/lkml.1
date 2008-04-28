Return-Path: <linux-kernel-owner+w=401wt.eu-S966529AbYD1VBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966529AbYD1VBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934507AbYD1VAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:00:48 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:1203 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbYD1VAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=s6HicQ/KjmWS+cohgR2GZsUPq2G+4kaq9qpDy2q/HObFBtPMnR+kynmA+a0mfcU+Bjsziaz6blaBmVzZxQrGl3vnA49cAMNAI6DSuVEX59Srx1jb7A/JXRdn4ugFbm46VNunZrnXdf39lMfY2UtnblsN/gnGGxk8FZMmrZ3gT0Y=
Message-ID: <517f3f820804281400n21223d11mf1e518b11660774b@mail.gmail.com>
Date: Mon, 28 Apr 2008 23:00:44 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] dup2 w/flags
Cc: "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org
In-Reply-To: <48163989.2000405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804280320.m3S3KSFu028466@devserv.devel.redhat.com>
	 <517f3f820804280243q4a4bb9dbv27ce4be90fdd5954@mail.gmail.com>
	 <48163989.2000405@zytor.com>
X-Google-Sender-Auth: 4ceafe3b79de1349
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/08, H. Peter Anvin <hpa@zytor.com> wrote:
> Michael Kerrisk wrote:
>
> >
> > Ulrich,
> >
> > To repeat my earlier request, and as requested in Documentation/HOWTO,
> > could you please CC me on API changes.  This alerts me to what may
> > eventually need documenting in man-pages.
> >
> >
>
>  I think we may need a mailing list for this; you're not the only person who
> would be affected by ABI-visible changes.

I've been thinking the same thing.

Perhaps linux-api@vger?
