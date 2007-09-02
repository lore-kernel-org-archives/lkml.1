Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbXIBUaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbXIBUaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbXIBUaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:30:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:47811 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbXIBUaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Jsom0YBC+i86QODec/CFse8wOmYV0i9q125ZwhqYT+MjVszE8thTPu0Yxjhj2TePLu8QEVgTpIr4p3poFuLYVZvQ173lmJJba+BFakoT6nyjhKlLFxx5sy3STLOxbKzTbAPRjuJhYVnoKtrpYoCjrJJo4dDlJVWW3S+GtNxQ9bI=
Message-ID: <9a8748490709021330g6d556c4fqf8b9b3f6f1196eee@mail.gmail.com>
Date: Sun, 2 Sep 2007 22:30:20 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Satyam Sharma" <satyam@infradead.org>
Subject: Re: [-mm patchset] War on warnings
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709030205300.29617@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.in>
	 <9a8748490709021304k37d7e42clc32a08d5ec0f4a75@mail.gmail.com>
	 <alpine.LFD.0.999.0709030205300.29617@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/07, Satyam Sharma <satyam@infradead.org> wrote:
>
>
> On Sun, 2 Sep 2007, Jesper Juhl wrote:
> >
> > Thank you for doing this, I hope some of your patches get merged.
> >
> > Btw; it would be easier to see if one has got all the patches if you
> > numbered your patch series with the usual "[PATCH XX/YY]".
>
> Hey, thanks ;-) There are 13 in all, I just felt lazy and simply used
> ^R from alpine in-reply-to the first mail one-after-another instead
> of scripting it ...
>
Hehe, I often do it that way myself, but just edit the subject of each
mail and manually put in the [PATCH XX/YY] bit.

It is just that sometimes mails get lost, so it's very nice to know
how many patches to expect in a series :)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
