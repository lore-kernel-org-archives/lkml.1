Return-Path: <linux-kernel-owner+w=401wt.eu-S1763428AbZD3OdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763428AbZD3OdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZD3OdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:33:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48036 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbZD3OdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:33:08 -0400
Date: Thu, 30 Apr 2009 09:32:44 -0500
From: Clark Williams <williams@redhat.com>
To: "Mao Yilu" <ylmao@mail.ustc.edu.cn>
Cc: "'Henrique de Moraes Holschuh'" <hmh@hmh.eng.br>,
       <linux-kernel@vger.kernel.org>
Subject: Re: TSC unstable on Intel Pentium M processor 750
Message-ID: <20090430093244.74fcb1af@torg>
In-Reply-To: <441077283.08393@ustc.edu.cn>
References: <440758024.12507@ustc.edu.cn>
	<441049102.10204@ustc.edu.cn>
	<654E14825BCE4C9B94E5986000DC9BCE@xiaomao>
	<441061189.03958@ustc.edu.cn>
	<441077283.08393@ustc.edu.cn>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3UEXUqu030623

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Thu, 30 Apr 2009 15:40:02 +0800
"Mao Yilu" <ylmao@mail.ustc.edu.cn> wrote:

> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org
> > [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Henrique de Moraes
> > Holschuh
> > Sent: Thursday, April 30, 2009 11:12 AM
> > To: Mao Yilu
> > Cc: 'Robert Hancock'; linux-kernel@vger.kernel.org
> > Subject: Re: TSC unstable on Intel Pentium M processor 750
> > 
> > On Thu, 30 Apr 2009, Mao Yilu wrote:
> > > But I still don't know why the TSC is not correct in the C1 state (hlt
> > > instruction). Is there anything more to influence the TSC? What happened
> > > when the CPU is not running under hlt instruction?
> > 
> > SMIs?  Laptops love that crap...
> 
> What is SMIs?
> 
>

System Management Interrupt. Usually handled by BIOS code and
completely invisible to Linux. 

Laptops and big servers (rackmount/blades) typically have tons of SMIs
going off to do thermal management, statisics and remote management.

Clark
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkn5tpkACgkQHyuj/+TTEp1CjgCfZkG+/AU9CJrTSrk/+XVqPszS
4aoAoNgvDoLRMRUs1VSXqBRyg2HzPs6U
=drzY
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
