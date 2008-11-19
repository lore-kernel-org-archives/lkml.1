Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbYKSGqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbYKSGqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYKSGpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:45:50 -0500
Received: from mailout-hades.uni-duesseldorf.de ([134.99.128.34]:52541 "EHLO
	mail.rz.uni-duesseldorf.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751312AbYKSGpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:45:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 19 Nov 2008 07:45:47 +0100 (CET)
From: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: Re: linux-m68k.git
In-reply-to: <Pine.LNX.4.64.0811182136060.27671@anakin>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Message-id: <alpine.DEB.1.00.0811190737360.5649@zirkon.biophys.uni-duesseldorf.de>
References: <Pine.LNX.4.64.0811182136060.27671@anakin>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Tue, 18 Nov 2008, Geert Uytterhoeven wrote:

> (Finally) I created an experimental git tree for Linux/m68k:
> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git

Sweet :-) Cloning already. 
 
> It contains more or less all patches I had in my quilt series at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-m68k-patches-2.6/
> A notable exception is m68k-PRIVATE-m68k-changes.diff, which hardcoded ARCH to
> m68k.
> 
> As suggested by David Woodhouse, I grouped the commits by topic. But unlike
> David's suggestion, I used topic branches, not topic repositories. Oh well,
> we'll see...

As most of your 'topcis' are rather small self-contained patch sets, that should 
be OK. 

Thanks so much!

	Michael
 
