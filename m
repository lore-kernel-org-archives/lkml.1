Return-Path: <linux-kernel-owner+w=401wt.eu-S1763263AbYCEWUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763263AbYCEWUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbYCEWRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:17:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42828
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764290AbYCEWRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:17:41 -0500
Date: Wed, 05 Mar 2008 14:17:40 -0800 (PST)
Message-Id: <20080305.141740.38485124.davem@davemloft.net>
To: matz@suse.de
Cc: Joe.Buck@synopsys.COM, hubicka@ucw.cz, aurelien@aurel32.net, hpa@zytor.com,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt
 direction flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803052241170.20583@wotan.suse.de>
References: <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
	<20080305212005.GC17267@synopsys.com>
	<Pine.LNX.4.64.0803052241170.20583@wotan.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Matz <matz@suse.de>
Date: Wed, 5 Mar 2008 22:43:33 +0100 (CET)

> The error is arcane and happens seldomly if at all.  And only on
> unfixed kernels.

Which translates right now into "all kernels."
