Return-Path: <linux-kernel-owner+w=401wt.eu-S1030342AbXBRGbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342AbXBRGbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 01:31:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030345AbXBRGbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 01:31:09 -0500
Received: from lollipop.listbox.com ([208.210.124.78]:33238 "EHLO
	lollipop.listbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030342AbXBRGbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 01:31:08 -0500
Subject: Re: [ck] Re: 2.6.20-ck1
From: Rodney Gordon II <meff@pobox.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, "mdew ." <some.nzguy@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <1171779357.4740.5.camel@ghreen.sphere>
References: <200702162110.03355.kernel@kolivas.org>
	 <1c1c86360702171814m35265b01pe391df87d5f9db76@mail.gmail.com>
	 <cone.1171766339.618918.14587.501@kolivas.org>
	 <1171779357.4740.5.camel@ghreen.sphere>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 00:20:13 -0600
Message-Id: <1171779613.4740.9.camel@ghreen.sphere>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 00:15 -0600, Rodney Gordon II wrote:
> On Sun, 2007-02-18 at 13:38 +1100, Con Kolivas wrote:
> > mdew . writes:
> > 
> > > On 2/16/07, Con Kolivas <kernel@kolivas.org> wrote:
> > >> This patchset is designed to improve system responsiveness and interactivity.
> > >> It is configurable to any workload but the default -ck patch is aimed at the
> > >> desktop and -cks is available with more emphasis on serverspace.
> > >>
> > >> Apply to 2.6.20
> > > 
> > > any benchmarks for 2.6.20-ck vs 2.6.20?
> > 
> > Would some -ck user on the mailing list like to perform a set of interbench 
> > benchmarks? They're pretty straight forward to do; see:
> > 
> > http://interbench.kolivas.org
> > 
> > --
> > -ck
> 
> Here are some benches comparing 2.6.18-4-686 (Debian sid stock) and
> 2.6.20-ck1-mt1 (2.6.20-ck1 + sched-idleprio-1.11-2.0.patch)
> 
> I know it's not what was asked for, but it might be useful for review of
> anyone using Debian kernels considering ck patches :)
> 
> Take a look.
> 
> -r

System specs by the way:
Pentium-D 830 3.0GHz Dualcore, 1.5GB RAM, 7200RPM 16MB Cache SATA3 using
AHCI w/ NCQ on.

-- 
Rodney "meff" Gordon II -*- meff@pobox.com
Systems Administrator / Coder Geek -*- Open yourself to OpenSource

