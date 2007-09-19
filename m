Return-Path: <linux-kernel-owner+w=401wt.eu-S1760878AbXISPh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760878AbXISPh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbXISPhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:37:48 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43645 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbXISPhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:37:47 -0400
Date: Wed, 19 Sep 2007 08:29:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Josh Boyer <jwboyer@jdub.homelinux.org>, linuxppc-dev@ozlabs.org,
       Linux@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Mailing List <linux-kernel@vger.kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc: Avoid pointless WARN_ON(irqs_disabled()) from
 panic codepath
Message-Id: <20070919082947.d9a33a70.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.0.999.0709191844360.7697@enigma.security.iitk.ac.in>
References: <46EA5CEB.7020104@linux.vnet.ibm.com>
	<a781481a0709140337u2c26f770h2af6d457bc39f280@mail.gmail.com>
	<alpine.LFD.0.999.0709180511070.8863@enigma.security.iitk.ac.in>
	<20070917183749.fd690505.randy.dunlap@oracle.com>
	<20070917204625.64b97392@vader.jdub.homelinux.org>
	<alpine.LFD.0.999.0709191844360.7697@enigma.security.iitk.ac.in>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 19:15:00 +0530 (IST) Satyam Sharma wrote:

> 
> In fact, it turns out OSDL's cross-compiler toolchains were built with
> crosstool itself. Should also add that those OSDL compilers are too old
> (gcc version 3.4.x-3.5.x mostly -- my build was totally spammed with those
> "+m" in asm constraints related warnings), so I'll try and build a few
> more recent ones (at least for the more popular platforms) over the
> weekend too.

Hi,
Please let us know if/when you have newer cross-compiler tarballs
available.

Thanks.
---
~Randy
