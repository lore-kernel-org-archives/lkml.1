Return-Path: <linux-kernel-owner+w=401wt.eu-S1423679AbXD3VeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423679AbXD3VeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 17:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423691AbXD3VeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 17:34:23 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423687AbXD3VeV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 17:34:21 -0400
Date: Mon, 30 Apr 2007 14:30:57 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Riccardo Ricci <rricci@nuovanetmore.it>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       Len Brown <len.brown@intel.com>, David Brownell <david-b@pacbell.net>,
       Jeff Mahoney <jeffm@suse.com>, reiserfs-dev@namesys.com,
       Jeff Chua <jeff.chua.linux@gmail.com>, Francois SIMOND <curio@free.fr>,
       netdev@vger.kernel.org,
       =?UTF-8?B?SMOla2Fu?= Lindqvist <lindqvist@netstar.se>,
       Vincent Frentzel <zcecc22@ucl.ac.uk>,
       =?UTF-8?B?RnJhbsOnb2lz?= Valenduc <francois.valenduc@skynet.be>,
       Thomas Meyer <thomas.mey@web.de>, Giorgio Lando <patroclo7@gmail.com>,
       Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.21 known regressions (v2) (for -stable team)
Message-ID: <20070430143057.41ec75db@freekitty>
In-Reply-To: <463375E5.5040108@googlemail.com>
References: <463375E5.5040108@googlemail.com>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Subject    : 2.6.21: sky2 "hw csum failure" problem
> References : http://lkml.org/lkml/2007/4/28/105
> Submitter  : Håkan Lindqvist <lindqvist@netstar.se>
> Status     : unknown
> 

This is not a "regression" it is a bug, that has shown up for
some users for quite a while, see:
 http://bugzilla.kernel.org/show_bug.cgi?id=7579


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
