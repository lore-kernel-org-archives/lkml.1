Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbXFOMl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbXFOMl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbXFOMlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:41:49 -0400
Received: from qb-out-0506.google.com ([72.14.204.226]:41668 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbXFOMls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:41:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ec1RBY+MbzHTsWZr9HzqIsR+cD3VeW3VB51ukZaM8D8v8aeOFzELVNofsE8DdE/mbPsLskXqcjWWDYh5rrWKA84SbVRAHMGhaDW+HLZuL8iAcev7+V74gyWzGAmbmrAlETYIc3voBuDQC0Lw0ciG6KsWbhCkvScMua1q8CUZGEg=
Message-ID: <d120d5000706150541g31dfd0c5ue86e99ede146a387@mail.gmail.com>
Date: Fri, 15 Jun 2007 08:41:45 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Bernd Paysan" <bernd.paysan@gmx.de>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Cc: "Paulo Marques" <pmarques@grupopie.com>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Krzysztof Halasa" <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <200706151014.45383.bernd.paysan@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466A3EC6.6030706@netone.net.tr>
	 <20070614170902.GQ21478@ftp.linux.org.uk>
	 <467178D3.6010204@grupopie.com>
	 <200706151014.45383.bernd.paysan@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/07, Bernd Paysan <bernd.paysan@gmx.de> wrote:
> On Thursday 14 June 2007 19:20, Paulo Marques wrote:
> > Watching the output of the first grep without "wc -l" shows that,
> > although it is not 100% accurate, it is still ok just to get a rough
> > estimate.
> >
> > So yes, ~6300 files are definitely more than a couple ;)
>
> Most of them don't say anything, so they are "any GPL" by the author.

Woah! Stop right there. Since when a work without a license spelled
out becomes "any GPL"?

> When
> do you people accept that Linus can't change the GPL, he can only add
> comments of what he thinks is the case! His interpretation of the GPLv2
> might be that not saying anything about the version means "v2 only", but if
> he does so, he's simply wrong. He was wrong in the module case, as well,
> and dropped this comment a while ago. He might drop this comment in future,
> as well. In fact, anybody can drop this comment, as it's just a comment.
>
> The kernel *as a whole* is clearly under GPLv2 only from Linus' comment,
> which is in fact true, since the common subset of GPL versions from all
> authors is indeed GPLv2 (by virtue of some files from Al Viro, and maybe
> some other explicit GPL v2 files). The author must specify the version
> himself, there simply is no other way. If you don't specify any, it's "any
> version", because I can license all patches straight from the authors.

Yes, you can. In this case you get _different_ software, maybe even
under different license. I bet if you go straight to the authors you
can get XFS or JFS under a commercial license, not GPL at all.

>  The
> way the GPLv2 allows you to explicitely specify "any version" is by not
> saying anything about the version at all.

Let me quote GPLv2 for you:

"If the Program specifies a version number of this License which
applies to it and "any later version", you have the option of
following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation."

As you can see for "ant later version" to apply the program must
explicitely say "This program is distributed under GPLv2 and any later
version". Supplying text of GPL v2 with the program does not
automatically add that clause. IOW, if copying file would litrally
read "Distributed under GPL v2. For the text of GPL v2 go to
www.fsf.org" woudl you still argue that it is "GPLv2 and later"?

-- 
Dmitry
