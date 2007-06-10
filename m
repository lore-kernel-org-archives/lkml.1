Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXFJM3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXFJM3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 08:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbXFJM3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 08:29:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:5234 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbXFJM3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 08:29:46 -0400
Date: Sun, 10 Jun 2007 14:29:45 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jesper Juhl <jesper.juhl@gmail.com>
cc: Tsugikazu Shibata <tshibata@ab.jp.nec.com>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, m-ikeda@ds.jp.nec.com
Subject: Re: [RFD] Documentation/HOWTO translated into Japanese
In-Reply-To: <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706101426040.12768@fbirervta.pbzchgretzou.qr>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
 <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 10 2007 14:24, Jesper Juhl wrote:
>
> If we start adding translated versions of documentation to the kernel
> source how should we organize the documents? Should each language get
> a sepperate directory in Documentation/ - like Documentation/JP/,
> Documentation/EN/, Documentation/DA/ etc?

I'd prefer the 'standardized' "ja_JP", "en_US", "de_DE", "nb_NO", etc.
as names.

> With multiple translated versions of the documentation in the tree,
> don't we run the risk that the translations will quickly become
> outdated since most people updating the documentation won't be able to
> update the translations?

What's more, the kernel tarball grows and grows :(



	Jan
-- 
