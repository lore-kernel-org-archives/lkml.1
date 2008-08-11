Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbYHKHUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbYHKHUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 03:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYHKHUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 03:20:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55463 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750839AbYHKHUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 03:20:41 -0400
Date: Mon, 11 Aug 2008 08:00:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "S K" <nospamnoham@gmail.com>
Cc: "Zhao Yakui" <yakui.zhao@intel.com>, "Thomas Renninger" <trenn@suse.de>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811080030.05a27bff@lxorguk.ukuu.org.uk>
In-Reply-To: <514e099a0808102224g6f55fa0ex5f50d8f21f838358@mail.gmail.com>
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com>
	<200808081430.43012.trenn@suse.de>
	<aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com>
	<200808092059.47863.trenn@suse.de>
	<514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com>
	<1218418431.6671.52.camel@yakui_zhao.sh.intel.com>
	<514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com>
	<1218432270.6671.75.camel@yakui_zhao.sh.intel.com>
	<514e099a0808102224g6f55fa0ex5f50d8f21f838358@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the LKML community consider the Fedora 9 kernels as too different?
> I would prefer using the F9 kernel for testing this issue since it's
> easier for me to compile and install.

The F9 kernels are very very close to the linux-kernel ones.

See

http://docs.fedoraproject.org/release-notes/f9/en_US/sn-Kernel.html
http://fedoraproject.org/wiki/Docs/CustomKernel
http://www.howtoforge.com/kernel_compilation_fedora
