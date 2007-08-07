Return-Path: <linux-kernel-owner+w=401wt.eu-S1765673AbXHGS7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765673AbXHGS7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 14:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXHGS7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 14:59:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:32810 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755978AbXHGS7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 14:59:42 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.22 regression: thermal trip points
Date: Tue, 7 Aug 2007 14:58:45 -0400
User-Agent: KMail/1.9.5
Cc: trenn@suse.de, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org
References: <46B1988C.3090302@t-online.de> <200708031459.07108.lenb@kernel.org> <20070806095504.GA1934@elf.ucw.cz>
In-Reply-To: <20070806095504.GA1934@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708071458.45687.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 05:55, Pavel Machek wrote:
> > For the
> > upstream kernel, I think it is more appropriate to expose and fix
> > the fundamental problems.  For distro kernels, I'm less concerned
> > if you hide bugs instead of fixing them.
> 
> This is okay as long as you are willing to work around the fundamental
> problems in kernel. You are unable to _fix_ them. They are broken
> BIOSes.

The thing Linux needs to figure out is why Windows doesn't
get confused by what Linux claims to be broken BIOS.

So far I have one live sighting to be addressed by
the upstream kernel (from Knut).  I'm certainly looking
forward to the 2nd live sighting...

-Len
