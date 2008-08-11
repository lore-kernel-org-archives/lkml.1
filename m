Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYHKQoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYHKQoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYHKQo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:44:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:48233 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYHKQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:44:26 -0400
Date: Mon, 11 Aug 2008 09:44:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: S K <nospamnoham@gmail.com>, Zhao Yakui <yakui.zhao@intel.com>,
       Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811094428.6b69d744@infradead.org>
In-Reply-To: <20080811162839.GA22450@cs181140183.pp.htv.fi>
References: <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	<200808092059.47863.trenn@suse.de>
	<514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	<1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	<514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	<20080811042244.469f8e1d@infradead.org>
	<20080811140206.GB3338@cs181140183.pp.htv.fi>
	<20080811071128.0165be50@infradead.org>
	<20080811160346.GB21292@cs181140183.pp.htv.fi>
	<20080811092047.42bf716b@infradead.org>
	<20080811162839.GA22450@cs181140183.pp.htv.fi>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 19:28:39 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> > 
> > yes there is.. for cases where there is overtemperature. Think of
> > it as the emergency break in the subway. You really don't want to
> > use it but when you need it you're glad it's there.
> 
> But this only helps when the cooling is working but not good enough,
> for the classic "fan broken" case it won't cool down enough.

I would call this an unclassified statement for which you have no data
to show that it's correct, at least for Intel cpus in general.

> 
> Does the Pentium 4 predate CPUs that shutdown when becoming too hot
> (I experienced such a shutdown recently on my Athlon...)?
> 

thermal shutdown is the last measure for sure (and it's in cpus yes)...
but sysadmins frown on that.. before you go down that path there's
various things that happen first (thermal throttle being one of them)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
