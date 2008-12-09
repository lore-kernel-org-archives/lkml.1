Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYLIIeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYLIIeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 03:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYLIIeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 03:34:13 -0500
Received: from ag-out-0708.google.com ([72.14.246.248]:40414 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYLIIeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 03:34:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=woAX3vfiAmZz0U3KzEiIfx5+VbBC8G+0AA4XhytM6XlHJPseHspAfq98C6fXUQYNvF
         +BQ/f1z6Xt9KQHtLDEZw2/UQCnfk6uXspWcq0JaZoirY3+ASv3k4mB4ZYv9n4WPTDVRo
         I8aO0x/N0MnzphvlMPHiNL+bN/CzuIaexv8UI=
Message-ID: <12bfabe40812090034s455edfe7uff3eb170c762404f@mail.gmail.com>
Date: Tue, 9 Dec 2008 09:34:10 +0100
From: "Giangiacomo Mariotti" <gg.mariotti@gmail.com>
To: "Mikael Abrahamsson" <swmike@swm.pp.se>
Subject: Re: OFFLIST Re: [HW PROBLEM] Intel I7 MCE. Erratum or not?
Cc: "Andi Kleen" <ak@linux.intel.com>,
       "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <12bfabe40812090030v7d8bcd6aq99438d18b808d32f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12bfabe40812060421j10c93b3dg75a48aa304f633e8@mail.gmail.com>
	 <493D296B.1080205@linux.intel.com>
	 <alpine.DEB.1.10.0812081724080.18782@uplift.swm.pp.se>
	 <493D6FB4.9090909@linux.intel.com>
	 <alpine.DEB.1.10.0812082145410.18782@uplift.swm.pp.se>
	 <12bfabe40812082146r3ea000em7a8f725101a50bd5@mail.gmail.com>
	 <alpine.DEB.1.10.0812090737410.18782@uplift.swm.pp.se>
	 <12bfabe40812082319x4ed6c9m5b744e51cdd3d838@mail.gmail.com>
	 <alpine.DEB.1.10.0812090857590.18782@uplift.swm.pp.se>
	 <12bfabe40812090030v7d8bcd6aq99438d18b808d32f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2008 at 9:30 AM, Giangiacomo Mariotti
<gg.mariotti@gmail.com> wrote:
> Yes, that happens to me too regularly. Also now my bios completely
> freezes after having successfully done the dmi pool check at boot if I
> try to boot directly from my HD, so I have to boot from my usb dvd
> writer. At the moment I successfully booted that rescuecd in 64 bit
> mode and the kexeced into my 2.6.27.8 debian system. I still haven't
> tried to make a bootable cd with grub and see if I can also boot
> directly into my HD at boot or if not even Grub can see it. The very
> good point of using the kexec method is that, even if my bios cannot
> boot my hd directly, I can bypass it. But I still don't know if I have
> this problem too.
>
Well, I'm not exactly sure that the dmi pool check is successful.
