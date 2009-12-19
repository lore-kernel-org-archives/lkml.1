Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbZLSSWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbZLSSWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 13:22:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZLSSWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 13:22:06 -0500
Received: from xenotime.net ([72.52.64.118]:38633 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752886AbZLSSWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 13:22:05 -0500
Date: Sat, 19 Dec 2009 10:22:23 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Robin Steven <armrobin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Can not generate ALSA driver documentation via Makefile
Message-Id: <20091219102223.506c9e9c.rdunlap@xenotime.net>
In-Reply-To: <8e678d3f0912190214s7ffbc3can784e8c907a6fe97@mail.gmail.com>
References: <8e678d3f0912190214s7ffbc3can784e8c907a6fe97@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Dec 2009 18:14:33 +0800 Robin Steven wrote:

> Hi, guy:
> 
> I am hacking ALSA driver for my customized board, and want to study
> the document "writing_an_alsa_driver" in
> "Documentation/sound/alsa/DocBook", in the top directory of kernel
> source and run:
> 
> $ make htmldocs
> 
> I can get all the html format document in "Documentation/DocBook", and
> no any html document in
> "Documentation/sound/alsa/DocBook" was converted for .tmpl to html.
> 
> Thanks in advenced for any one can give me any idea!

I guess it depends on what kernel version you are trying to use
(and you omitted that info).

With 2.6.32-git14, I see all of the input & generated alsa files
under Documentation/DocBook/, including "writing_an_alsa_driver".

Can you try a more recent (or current) kernel version?

---
~Randy
