Return-Path: <linux-kernel-owner+w=401wt.eu-S1946472AbXBCPjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946472AbXBCPjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946476AbXBCPjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:39:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:31546 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946472AbXBCPjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:39:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gTl+pHis0vtCu2SpwLyjvDxLiQaeidp5+B1yGQY8EJODgBFk7dXXkmyRSDYUXRf0y5Rb0JzAjw/a2x/b0y0c4MeczixeGBnruRfCXmFHEtXh1LlVY1o3jYYKiwuAvw0ZnVSuxu/rELulbr3Mt+zw7ClUQz75JH4n8YEY6LcV4W8=
Message-ID: <4af2d03a0702030739n77afadf4t8d26d66416b075e1@mail.gmail.com>
Date: Sat, 3 Feb 2007 16:39:34 +0100
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: Re: [PATCH 1/2] Char: add __devinitdata to pci_device_ids
Cc: "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Cyclades team" <async@cyclades.com>, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, nils@kernelconcepts.de, wim@iguana.be,
       R.E.Wolff@bitwizard.nl, "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <58cb370e0702030731i61b32e93j3f7a8f0e061cb136@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2106930977152662464@wsc.cz>
	 <58cb370e0702030731i61b32e93j3f7a8f0e061cb136@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/3/07, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On 2/3/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > add __devinitdata to pci_device_ids
> >
> > Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>
> http://lkml.org/lkml/2003/8/1/135
>
> I think that it is still true, Greg?

Hmm, then I misunderstood this:
http://lkml.org/lkml/2007/1/17/136
?

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
