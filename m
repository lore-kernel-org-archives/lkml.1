Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbXEOVQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbXEOVQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 17:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXEOVQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 17:16:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:20159 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbXEOVQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 17:16:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Adl55IzVzgJ6W4wXaZZUOL8joQcmirs87yRHgPyRBAS9wvMGLYDlMS5NXNB4IBFwy+gVjFbgvNc7owdwojYpl3VUQGGaSIjI+GriOMAwDDrf0QnWdN0NNfK+qRpXEtfSk6shZLpyQaPMs3Ea+jophMoqXmDmXn5Sdu0QQj0qJQ8=
Message-ID: <d120d5000705151416v4dafa176h556d03d692170b39@mail.gmail.com>
Date: Tue, 15 May 2007 17:16:47 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: jroberson@gtcocalcomp.com
Subject: Re: [linux-usb-devel] Cannot find our GTCO USB Driver in the 2.6.22-rc1 kernel
Cc: "Till Harbaum / Lists" <lists@harbaum.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Greg KH" <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1179255411.3101.79.camel@EdgyEft.Home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1176912010.6215.17.camel@EdgyEft.Home>
	 <20070515111250.e869634b.randy.dunlap@oracle.com>
	 <1179252727.3101.68.camel@EdgyEft.Home>
	 <200705152038.53676.lists@harbaum.org>
	 <1179255411.3101.79.camel@EdgyEft.Home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 5/15/07, Jeremy Roberson <jroberson@gtcocalcomp.com> wrote:
> A very good question.  Had it been, I probably would not have missed it.
>
> On Tue, 2007-05-15 at 20:38 +0200, Till Harbaum / Lists wrote:
> > Hi,
> >
> > which leads to the question: Why is the "Enable Tablets" entry not
> > inside the tablets menu. This way it's more obvious that it's disabled
> > if it's the only entry in the menu. Plus the parent menu gets
> > cleaned up as well.
> >

Because some people want to be able to turn off entire set of options
without having to descend into submenu.

-- 
Dmitry

P.S. Please do not top-post.
