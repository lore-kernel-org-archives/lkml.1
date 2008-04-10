Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbYDJXw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbYDJXw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 19:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbYDJXwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 19:52:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:10214 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbYDJXwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 19:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Gbbjxji8bqRqMZB45gYbg6IEtvdnSdEn0rM0rsK7X2vWxEv7wRa2S6fWrL+I3o+Z60u3x38FmVY28ymQzyqt2/9MvvR8vuCYdXTj+P7ENyaOF4L6fR+lYOQ4MvjqEIOcASnfavPG/C89oXupW4l8cPqcHtP9WjlkoVSB6xmcLss=
Message-ID: <ed10ee420804101652w467f4d1pc58da3736d7f54c7@mail.gmail.com>
Date: Thu, 10 Apr 2008 16:52:49 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Benny Halevy" <bhalevy@panasas.com>
Subject: Re: [patch] checkpatch: relax spacing and line length
Cc: "Andy Whitcroft" <apw@shadowen.org>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <rdunlap@xenotime.net>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <47FCF6AF.8010703@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>
	 <20080408171257.GF17915@shadowen.org> <47FCB458.3070403@panasas.com>
	 <20080409132548.GM17915@shadowen.org> <47FCF6AF.8010703@panasas.com>
X-Google-Sender-Auth: 156063d416ea6979
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/08, Benny Halevy <bhalevy@panasas.com> wrote:

>  In http://lkml.org/lkml/2008/2/26/533,
>  SL Baur <steve <at> xemacs.org> said:
>  > The proposed two space change is ugly.  Can someone NAK it?
>
>  I'm not sure what "two space change" proposal this Steve referred to
>  and his rejection is based on not-to-sound aesthetic grounds.
>
>  The motivation behind our proposal is more than just aesthetic.
>  I believe that using tabs for indent and then spaces for alignment
>  is functionally better, works for everybody, and will eventually result
>  in a more readable code over time, hopefully leading to fewer bugs.

Tabs + a variable number spaces to match up logically with the
previous line is O.K.  Tabs + exactly two spaces is what I objected
to.  I only posted due to being the originator of the Linux Kernel Emacs
cc-mode style and cc-mode works like the former.

For whatever it's worth, my sentiments are on the David Miller side,
having been the lucky recipient of format changes only patch bombs
before.  I suppose you should be glad you don't have someone running
a spell checker on the entire source code.

-sb
