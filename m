Return-Path: <linux-kernel-owner+w=401wt.eu-S933799AbYBBUXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933799AbYBBUXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 15:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYBBUXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 15:23:24 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33571 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYBBUXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:23:23 -0500
Date: Sat, 2 Feb 2008 21:23:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] Instrumentation Menu Removal
Message-ID: <20080202202327.GA26341@uranus.ravnborg.org>
References: <20080202201031.860344390@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202201031.860344390@polymtl.ca>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 03:10:31PM -0500, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> Here are the updated instrumentation menu removal patches. They apply on top of
> 2.6.24-git12. I took tare of the underlying architecture changes that happened
> recently (avr32 and arm especially).
> 
> Patch order :
> # instrumentation menu removal
> fix-arm-to-play-nicely-with-generic-instrumentation-menu.patch
> create-arch-kconfig.patch
> add-have-oprofile.patch
> add-have-kprobes.patch
> move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch

I picked this serie up in kbuild.git.

	Sam
