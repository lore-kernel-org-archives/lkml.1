Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbYBOMmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbYBOMmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 07:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYBOMmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 07:42:08 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:29302 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYBOMmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 07:42:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=p4Cz+Yg/P+TmiHPzIkvCxSQ7tjNKlQJmQhWkp33TB3GlXyAM/cOqc+c8y757P8ICJih28BhcmEHQ4mHS47llhODTZ3VHFHjJXvRiaS2PfEFLgH+ishzaC/PHb8NkHlKNnoaL661Yf1MKELw14LULLe/0ysYZFUAGwQlJFJ2bNyg=
Message-ID: <dc1166600802150442w7787b372pb91be1f51919f00@mail.gmail.com>
Date: Fri, 15 Feb 2008 23:42:03 +1100
From: "Michael Ellerman" <michael@ellerman.id.au>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: linux-next build status
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47B4E9CB.3090708@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215114253.ddf3f929.sfr@canb.auug.org.au>
	 <47B4E9CB.3090708@redhat.com>
X-Google-Sender-Auth: 501b765bed60e1cf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 12:24 PM, Chris Snook <csnook@redhat.com> wrote:
> Stephen Rothwell wrote:
>  > Hi all,
>  >
>  > Initial status can be seen here
>  > http://kisskb.ellerman.id.au/kisskb/branch/9/ (I hope to make a better
>  > URL soon).  Suggestions for more compiler/config combinations are
>  > welcome, but we can't necessarily commit to fulfilling all you
>  > wishes.  :-)
>  >
>
>  i386 allmodconfig please.
>
>  Also, I highly recommend adding some randconfig builds, at least one 32-bit arch
>  and one 64-bit arch.  Any given randconfig build is not particularly likely to
>  catch bugs that would be missed elsewhere, but doing them daily for two months
>  will catch a lot of things before they get released.  The catch, of course, is
>  that you have to actually save the .config for this to be useful, which might
>  require a slight modification to your scripts.

It does save the configs, so randconfig might be an option. I'll look
at it next week.

cheers
