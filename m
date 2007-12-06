Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbXLFQDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbXLFQDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbXLFQDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:03:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:61735 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbXLFQDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:03:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QF3C7VSiLZ5DqPkFrlfZ4xy7qRVh/5vHcq866PV0ge039NpCxXV9/FxsmQcGLF/jXFLsq5hFn22MOMmYLjnBYVV8blRBLpLUYO2BnyH4Z3d9S7Si/M4qVPNNS5XcQI0cw+YzjViwjuLBBh8JJUndJMQWEIDQ4ZHIePGD2qQ07ZU=
Message-ID: <8499950a0712060803j59aaf750kbbb4a249e181559d@mail.gmail.com>
Date: Thu, 6 Dec 2007 16:03:05 +0000
From: "Oleg Verych" <olecom@gmail.com>
To: "Hollis Blanchard" <hollisb@us.ibm.com>
Subject: Re: mkasm-offsets.sh ?
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1196878474.2088.34.camel@basalt>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1196805584.7475.33.camel@basalt>
	 <8499950a0712042349m313455adlc71df0886eb2bba4@mail.gmail.com>
	 <1196878474.2088.34.camel@basalt>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 5, 2007 6:14 PM, Hollis Blanchard <hollisb@us.ibm.com> wrote:
>
> On Wed, 2007-12-05 at 07:49 +0000, Oleg Verych wrote:
> > On Dec 4, 2007 9:59 PM, Hollis Blanchard <hollisb@us.ibm.com> wrote:
> > > Hi, I found this thread: http://lkml.org/lkml/2007/4/1/237
> > >
> > > I guess the complete patch was never finished? I could sure it (for
> > > pretty much the same reason as lguest).
> >
> > It was, but untested (widely). The (google) search keyword is
> > "asm-values", because there are much more things, than just offsets.
>
> Thanks for the pointer. Could you please provide a Signed-off-by line,
> so that other people can modify and extend your work?

Signed-off-by: Oleg Verych <olecom@flower.upol.cz>

It was not copyrighted "art" work anyway. Also, i have no access to the original
e-mail service now, sorry.

Hope, this helps.
_______
