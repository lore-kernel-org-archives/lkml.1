Return-Path: <linux-kernel-owner+w=401wt.eu-S932959AbXA1XBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbXA1XBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932960AbXA1XBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:01:53 -0500
Received: from main.gmane.org ([80.91.229.2]:43334 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959AbXA1XBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:01:51 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Eriberto <eriberto@eriberto.pro.br>
Subject: Re: swap: which is the maximum size allowed?
Date: Sun, 28 Jan 2007 21:01:34 -0200
Message-ID: <epja0g$5fn$1@sea.gmane.org>
References: <7IoP9-5nQ-27@gated-at.bofh.it> <E1HBIkM-0001I5-9q@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 201.22.134.243.adsl.gvt.net.br
User-Agent: IceDove 1.5.0.9 (X11/20061220)
In-Reply-To: <E1HBIkM-0001I5-9q@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. But, mkswap man is old (1999). However, from Linux Partition HOWTO:

"footnote: "official" max swap size: With kernel 2.4, the limit is 64
swap spaces at a maximum of 64Gb each, although this is not reflected in
the man page for mkswap. With the 64 bit opteron on the 2.6 kernel, 128
swap areas are permitted, each a whopping 16 Tb! (thanks to Peter Chubb
for the calculation)"

I want to know: why 64 GB???

Thanks,

Eriberto - www.eriberto.pro.br

Bodo Eggert escreveu:
> Look into the manpage of mkswap. It's 2 G x 32 swap partitions,
> minus a tiny overhead.

