Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbXFZJsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbXFZJsr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXFZJsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:48:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXFZJsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:48:39 -0400
From: Jan Kandziora <jjj@gmx.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Limiting load of certain processes
Date: Tue, 26 Jun 2007 11:48:31 +0200
User-Agent: KMail/1.9.5
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200706211950.40825.jjj@gmx.de> <Pine.LNX.4.64.0706212110440.26568@fbirervta.pbzchgretzou.qr> <200706260444.35818.maximlevitsky@gmail.com>
In-Reply-To: <200706260444.35818.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706261148.32478.jjj@gmx.de>
X-Provags-ID: V01U2FsdGVkX19/bzaEODiszMj3xAOPuixb+HacGgcYfQPpM4j
 NaLbVjrVMOb027MybblC24g2KC/HTv3OCa32+MBaXhv9cNXfW6
 g6NU7ENBNpExxz9qwc2lA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 26. Juni 2007 03:44 schrieb Maxim Levitsky:
>
> Hi.
>
> Try  to set $_hogthreshold = (1) in dosemu.conf
>
> This helps a lot for me.
>
This "nice"s the dosemu process -- I already use this setting. However, if no 
other process is runnable, dosemu will get again all CPU power, which 
disturbs power-saving. Thanks for sharing ideas, anyway.

Kind regards

	Jan
