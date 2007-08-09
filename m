Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbXHIT6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbXHIT6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbXHIT6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:58:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:15750 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126AbXHIT6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e1H8g0wRZ4ZcqE/7mnc7PH27v1l+qvKjBIwvAhhqem1udasUKhC6FXbr1vXTvZy+3S6n9gVYPvYWCLFG1dZRq4BysPVYiSsVARsFNvOqJOy2/LATStGMi/FUValGB7s3dZHf2FejyHIqjIkY1DtLFrUGpv3NtIs2vuxJ6BFIbYQ=
Message-ID: <b2d05de20708091258p1681bc99j4532fc42bbbb20c8@mail.gmail.com>
Date: Thu, 9 Aug 2007 12:58:10 -0700
From: "Brennan Ashton" <comphappy@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: Documentation files in html format?
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <46BB67A4.7040402@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809113122.3aa508e4@oldman.hamilton.local>
	 <46BB67A4.7040402@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Stephen Hemminger wrote:
> > Advantages of html:
> >   * basic formatting like lists, italics, etc
>
> Plaintext has lists too.  See for example
> <20070809113122.3aa508e4@oldman.hamilton.local>.  ;-)
>
> It's also possible to approximate bold face, italics, and underlines in
> plaintext.
>
> >   * easier to integrate into other places and retain formatting
>
> Out-of-tree places?
>
> >   * ability to link documents and to external sources easier
>
> In which way are URIs and other references in HTML easier than in plaintext?
>
> > Downsides:
> >   * can become too formatted and unclear
> >   * accessibility and translation issues?
> >   * even more style issues
>
> Indeed.
> --
> Stefan Richter
> -=====-=-=== =--- -=--=
> http://arcgraph.de/sr/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
I am with you on this one, i am less than convinced that HTML is
better, IMHO it is a wrong direction.  Plain Text documentation is one
of the things i love about linux, it has worked for so many years why
change now. As Stefan explained there are simple ways to get around
all of the points that you gave.

-- 
Brennan Ashton
