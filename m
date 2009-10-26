Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbZJZT52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbZJZT52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZJZT51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:57:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37299 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753981AbZJZT51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:57:27 -0400
Date: Mon, 26 Oct 2009 19:59:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Ryan C. Gordon" <icculus@icculus.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel modules.
Message-ID: <20091026195904.16a0be2d@lxorguk.ukuu.org.uk>
In-Reply-To: <4AE5F4FB.3000506@goop.org>
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan>
	<4ADD0086.9060304@goop.org>
	<alpine.DEB.2.00.0910200043200.18342@andre.icculuslan>
	<4AE22D04.50708@goop.org>
	<20091024121421.2e530635@lxorguk.ukuu.org.uk>
	<4AE5F4FB.3000506@goop.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mode of operation (since at least at one point vendors shipping binary
> modules would seem to include a few enterprise distro builds and hope
> that would cover it).  But that doesn't seem like a very good idea.

If you want to ship additional modules you can already do that, the
kernel search path is dependant upon the kernel name.
