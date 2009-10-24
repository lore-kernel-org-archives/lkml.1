Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZJXLMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZJXLMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 07:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZJXLMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 07:12:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49547 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751886AbZJXLMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 07:12:50 -0400
Date: Sat, 24 Oct 2009 12:14:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Ryan C. Gordon" <icculus@icculus.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel modules.
Message-ID: <20091024121421.2e530635@lxorguk.ukuu.org.uk>
In-Reply-To: <4AE22D04.50708@goop.org>
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan>
	<4ADD0086.9060304@goop.org>
	<alpine.DEB.2.00.0910200043200.18342@andre.icculuslan>
	<4AE22D04.50708@goop.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, ideally a fat module would allow modules for multiple kernels to
> be bundled together (same and/or different architectures), which is
> primarily useful for 3rd-party binary distributions.

You would need thousands and thousands of binaries to do that. I'm not
sure the gigabyte sized module file would be too popular. It would be
easier to recompile it even automatically (take a look at the Dell stuff
for this)

Alan
