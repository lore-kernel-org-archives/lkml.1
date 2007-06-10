Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbXFJQiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbXFJQiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbXFJQiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:38:12 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36896 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbXFJQiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:38:12 -0400
Date: Mon, 11 Jun 2007 01:34:51 +0900 (JST)
Message-Id: <20070611.013451.74739872.tshibata@ab.jp.nec.com>
To: gregkh@suse.de
Cc: jesper.juhl@gmail.com, linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com,
       tshibata@ab.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
In-Reply-To: <20070610162221.GA12830@suse.de>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
	<9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
	<20070610162221.GA12830@suse.de>
X-Mailer: Mew version 4.2 on Emacs 20.7 / Mule 4.1
 =?iso-2022-jp?B?KBskQjAqGyhCKQ==?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007 09:22:21 -0700, gregkh wrote:
> On Sun, Jun 10, 2007 at 02:24:51PM +0200, Jesper Juhl wrote:
> >  On 10/06/07, Tsugikazu Shibata <tshibata@ab.jp.nec.com> wrote:

> > > Actually, this is my first trial to post Japanese translated document
> > > and here are some points I decided ;
> > >
> > > - Character encoding is ISO-2022-JP, which is normally used for email
> > >   using Japanese.
> > 
> >  I think there's consensus that documents in the kernel source should
> >  be either plain ASCII or UTF-8 (doesn't UTF-8 work for japanese?).
> 
> Is it hard to convert it to UTF-8?

NO, it's easy.

iconv -f ISO-2022-JP -t UTF-8 <infile >outfile

We are usually using ISO-2022-JP for email exchange and if anyone
would comment on my document, this is better I believe.
For documentation purpose, I agree with UTF-8.

Thanks,
Tsugikazu Shibata
