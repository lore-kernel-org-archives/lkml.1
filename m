Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbXBDT7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbXBDT7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 14:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXBDT7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 14:59:25 -0500
Received: from nz-out-0506.google.com ([64.233.162.230]:62356 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbXBDT7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 14:59:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Vpm326xniMdaerT66TqfKaSsG8TYkiWa8rIIchKA+khKbAjbP1rtK2u3sRXUnWCDqctxrnli/xvHkn7s5qynx5T6Ddy//tH1CDhRoeCB2N8zPJ5IUZL2LWVvGpDIarLeuYgAWcqR9/igkUjilqj6lnVPs3+sWS+HK1cxJ2309eY=
Message-ID: <8d158e1f0702041159m45a70303lf0fc3ce71b8f946a@mail.gmail.com>
Date: Sun, 4 Feb 2007 20:59:23 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: More pata_ stuff
Cc: "Alistair John Strachan" <s0348365@sms.ed.ac.uk>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <8d158e1f0702041139k658e6d6dv52e7b3c68ef146e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.0NlWYh2G2PI5gqX24xfe+268eQY@ifi.uio.no>
	 <45C619FC.3040804@shaw.ca>
	 <8d158e1f0702041020yd1ad858m77538b198d467797@mail.gmail.com>
	 <200702041910.46421.s0348365@sms.ed.ac.uk>
	 <20070204193441.6746bbca@localhost.localdomain>
	 <8d158e1f0702041129n578a4a58xe8cb2a5f4da69284@mail.gmail.com>
	 <20070204194909.136dccc5@localhost.localdomain>
	 <8d158e1f0702041139k658e6d6dv52e7b3c68ef146e1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/4/07, Patrick Ale <patrick.ale@gmail.com> wrote:
> On 2/4/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> \
> > OLDPIIX is for "old" PIIX devices only - from pentium era. It does not
> > cover the later chips at all

Just to make sure, this is a P2 SMP board, Slot A, doesnt even support P3 CPUs.
The board is something like, 5 years old or so. Which driver *should*
work for me?

The board even has *gasp* ISA slots and doesnt support anything more
than UDMA33 :D
