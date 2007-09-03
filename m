Return-Path: <linux-kernel-owner+w=401wt.eu-S1756991AbXICIH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756991AbXICIH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbXICIGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:06:49 -0400
Received: from main.gmane.org ([80.91.229.2]:45316 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbXICIGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:06:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: 2.6.23-rc4-mm1
Date: Mon, 3 Sep 2007 08:06:25 +0000 (UTC)
Message-ID: <loom.20070903T100420-157@post.gmane.org>
References: <20070902045634.06ea0515@loke.fish.not>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 192.54.193.51 (Mozilla/5.0 (Windows; U; Windows NT 5.0; fr; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mats Johannesson <spamcan <at> bredband.net> writes:

> 
> On 2007-09-01 16:07:48 Torsten Kaiser wrote:
> [...]
> > The good:
> >> +hpet-force-enable-on-vt8235-37-chipsets.patch
> >> +hpet-force-enable-on-vt8235-37-chipsets-fix.patch
> >
> > Kernel 2.6.23-rc4-mm1 works on one of my systems with:
> > 00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host
> > Bridge (rev 01)
> > 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge
> > [K8T800/K8T890 South]
> 
> And glory, glory, my Acer Aspire 1520 (1524) AMD64 notebook with the
> old vt8235 chipset got a good kick in the behind as well. 

Now we have working HPET override for Intel and Via, could Nvidia users be
considered too? The required info has been known for ages:

http://marc.info/?l=linux-kernel&m=117679014505031

Regards,

-- 
Nicolas Mailhot

