Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbYLLNey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbYLLNey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbYLLNer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:34:47 -0500
Received: from www.tglx.de ([62.245.132.106]:60352 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbYLLNeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:34:46 -0500
Date: Fri, 12 Dec 2008 14:34:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove simnow earlyprintk support
In-Reply-To: <20081021120500.GA21453@basil.nowhere.org>
Message-ID: <alpine.LFD.2.00.0812121434090.17621@localhost.localdomain>
References: <20081021120500.GA21453@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008, Andi Kleen wrote:

> Remove simnow earlyprintk support
> 
> The later versions of SimNow! actually all have serial console
> emulation, so the direct interface isn't needed anymore.
> So remove the undocumented simnow earlyprintk console.

Applied. Thanks,

	 tglx
