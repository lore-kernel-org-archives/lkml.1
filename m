Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbYCURIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbYCURIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYCURIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:08:12 -0400
Received: from www.tglx.de ([62.245.132.106]:52304 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbYCURIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:08:11 -0400
Date: Fri, 21 Mar 2008 18:07:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST] [3/3] Replace macro recursion with more conventional
 loop
In-Reply-To: <20080311012322.B1E221B41CE@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803211806590.3781@apollo.tec.linutronix.de>
References: <20080311223.655043226@firstfloor.org> <20080311012322.B1E221B41CE@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Andi Kleen wrote:
> The early exception handlers are currently set up using a macro
> recursion. Replace that with a standard loop.
> 
> Noop patch, just a cleanup.

Cleanups before code changes please.
 
Thanks,
	tglx
