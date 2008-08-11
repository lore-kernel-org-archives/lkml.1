Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYHKOHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYHKOHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbYHKOHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:07:47 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54224 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYHKOHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:07:46 -0400
Date: Mon, 11 Aug 2008 15:07:34 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, S K <nospamnoham@gmail.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811140734.GA27959@srcf.ucam.org>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com> <200808081430.43012.trenn@suse.de> <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com> <200808092059.47863.trenn@suse.de> <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com> <1218418431.6671.52.camel@yakui_zhao.sh.intel.com> <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com> <20080811042244.469f8e1d@infradead.org> <20080811140206.GB3338@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811140206.GB3338@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 05:02:06PM +0300, Adrian Bunk wrote:

> This statement is only true for HPC environments and when you measure 
> Watts per work done.
> 
> But if you have some desktop or server with a load that is determined by 
> when it gets used, then p4-clockmod can actually save energy when the 
> computer is not under high load or even idle.
> 
> Or do I miss anything?

On modern hardware, the C states will win you more than downclocking the 
processor would.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
