Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZJTEyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZJTEyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZJTEyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:54:45 -0400
Received: from icculus.org ([67.106.77.212]:41510 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZJTEyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:54:44 -0400
Date: Tue, 20 Oct 2009 00:54:34 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@andre.icculuslan
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] binfmt_elf: FatELF support for kernel
 modules.
In-Reply-To: <4ADD0086.9060304@goop.org>
Message-ID: <alpine.DEB.2.00.0910200043200.18342@andre.icculuslan>
References: <alpine.DEB.2.00.0910190422090.13303@andre.icculuslan> <4ADD0086.9060304@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Allows kernel modules to be FatELF binaries.
> 
> This seems much more dubious.  It would only encourage more binary
> modules, which we're not very keen on doing.

I can understand that concern, but I worry about refusing to take steps 
that would aid free software developers in case it might help the 
closed-source people, too.

Those that will behave badly will do so regardless of file formats, but 
distros shipping nothing but GPL'd software and in-tree drivers would 
benefit from this more than another misguided company that probably 
doesn't care about multiple CPU architectures anyhow.

--ryan.


