Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYKIMpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYKIMpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 07:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbYKIMpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 07:45:04 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:34319 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbYKIMpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 07:45:03 -0500
Date: Sun, 9 Nov 2008 12:44:54 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: apic - use pr_ macros for logging
In-Reply-To: <4916c290.0c07560a.4a14.ffffdde9@mx.google.com>
Message-ID: <alpine.LFD.1.10.0811091239360.25325@ftp.linux-mips.org>
References: <20081109105709.222708517@gmail.com>> <4916c290.0c07560a.4a14.ffffdde9@mx.google.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 1970, Cyrill Gorcunov wrote:

> Impact: cleanup
> 
> It saves us some sourcse lines and shift
> the code a bit righter.
> 
> And a multiline comment style is fixed too :-)
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>  arch/x86/kernel/apic.c |  116 ++++++++++++++++++++++---------------------------
>  1 file changed, 53 insertions(+), 63 deletions(-)

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Thanks, Cyrill -- it was high time to get this done.  And, BTW, at the 
next opportunity please fix up your date -- I think it may confuse some 
people and/or scripts.  Good to know it was a Thursday though. ;)

  Maciej
