Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYAOQbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYAOQbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYAOQbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:31:10 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:56781 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbYAOQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:31:09 -0500
Date: Tue, 15 Jan 2008 11:31:08 -0500
To: Alejandro Riveira Fern??ndez <ariveira@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Tuomo Valkonen <tuomov@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080115163108.GD2308@csclub.uwaterloo.ca>
References: <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> <20080113231150.GB23906@mit.edu> <20080114071555.GA6475@jolt.modeemi.cs.tut.fi> <1200303743.24517.6.camel@tara.firmix.at> <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi> <m3d4s4yb4s.fsf@maximus.localdomain> <20080114110328.GA29126@jolt.modeemi.cs.tut.fi> <m3myr8vakf.fsf@maximus.localdomain> <20080114161828.GO2310@csclub.uwaterloo.ca> <20080115001351.74465792@Varda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115001351.74465792@Varda>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 12:13:51AM +0100, Alejandro Riveira Fern??ndez wrote:
>  My experience too with a Uli 1697 based mb. Estrange clock behaviour with
> kernel around .15-20 but fixed now (suffering too with ext3 fsck now i use jfs)
> 
>  Back in the day i blamed the new mb but now that it runs fine i can only blame
> the kernel or ubuntu user space.

A lot was due to bugs in the BIOS setup on many of the boards, and a few
even due to bugs in the chip design (like ATI's as far as I remember),
which the kernel then had to detect and work around.

--
Len Sorensen
