Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbXIDPWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbXIDPWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 11:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXIDPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 11:22:38 -0400
Received: from pascoe.ucs.ed.ac.uk ([129.215.128.240]:43855 "EHLO
	pascoe.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbXIDPWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 11:22:37 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Subject: Re: 2.6.23-rc4-mm1
Date: Tue, 4 Sep 2007 16:20:47 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
References: <20070902045634.06ea0515@loke.fish.not> <loom.20070903T100420-157@post.gmane.org>
In-Reply-To: <loom.20070903T100420-157@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041620.47213.alistair@devzero.co.uk>
X-Edinburgh-Scanned: at pascoe.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus, Clam AntiVirus
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2007 09:06:25 Nicolas Mailhot wrote:
> Mats Johannesson <spamcan <at> bredband.net> writes:
> > On 2007-09-01 16:07:48 Torsten Kaiser wrote:
> > [...]
> >
> > > The good:
> > >> +hpet-force-enable-on-vt8235-37-chipsets.patch
> > >> +hpet-force-enable-on-vt8235-37-chipsets-fix.patch
> > >
> > > Kernel 2.6.23-rc4-mm1 works on one of my systems with:
> > > 00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host
> > > Bridge (rev 01)
> > > 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge
> > > [K8T800/K8T890 South]
> >
> > And glory, glory, my Acer Aspire 1520 (1524) AMD64 notebook with the
> > old vt8235 chipset got a good kick in the behind as well.
>
> Now we have working HPET override for Intel and Via, could Nvidia users be
> considered too? The required info has been known for ages:
>
> http://marc.info/?l=linux-kernel&m=117679014505031

Seconded. It's been largely ignored which is annoying because the HPET works 
perfectly on this board. I assume the reason is still that nobody from NVIDIA 
verified hardward support for the hack.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
