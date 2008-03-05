Return-Path: <linux-kernel-owner+w=401wt.eu-S1765367AbYCEWVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765367AbYCEWVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765227AbYCEWVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:21:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51599
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765203AbYCEWVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:21:34 -0500
Date: Wed, 05 Mar 2008 14:21:33 -0800 (PST)
Message-Id: <20080305.142133.213259829.davem@davemloft.net>
To: bunk@kernel.org
Cc: matz@suse.de, clattner@apple.com, hpa@zytor.com,
       richard.guenther@gmail.com, Joe.Buck@synopsys.com, hubicka@ucw.cz,
       aurelien@aurel32.net, linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt
 direction flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080305221303.GA937@cs181133002.pp.htv.fi>
References: <738B72DB-A1D6-43F8-813A-E49688D05771@apple.com>
	<Pine.LNX.4.64.0803052258530.20583@wotan.suse.de>
	<20080305221303.GA937@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Thu, 6 Mar 2008 00:13:04 +0200

> On Wed, Mar 05, 2008 at 10:59:21PM +0100, Michael Matz wrote:
> > The problem is with old kernels, which by definition stay unfixed.
> 
> Compiling older kernels with new gcc versions has never been supported.

Adrian we're talking about userland binaries compiled by
gcc-4.3, not the kernel.

Please follow the discussion if you'd like to contribute.

Thanks.
