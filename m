Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZAEUho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZAEUho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZAEUhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:37:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48460
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752971AbZAEUhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:37:33 -0500
Date: Mon, 05 Jan 2009 12:37:34 -0800 (PST)
Message-Id: <20090105.123734.137888898.davem@davemloft.net>
To: mingo@elte.hu
Cc: sam@ravnborg.org, kosaki.motohiro@jp.fujitsu.com, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: irqnr fallout in gpiolib on sparc32
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090105135508.GB4190@elte.hu>
References: <20090105133819.GE6014@elte.hu>
	<20090105134832.GA14460@uranus.ravnborg.org>
	<20090105135508.GB4190@elte.hu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 5 Jan 2009 14:55:08 +0100

> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Dave has mentioned this but we are not working actively on it yet.
> 
> would be cool to do it - i think sparc32 is one of the last major physical 
> architectures to not be on genirq -

m68k remains to be converted over to genirq as well
