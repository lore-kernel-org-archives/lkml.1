Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbYJRRhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbYJRRhy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 13:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYJRRhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 13:37:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:50816 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbYJRRhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 13:37:46 -0400
Date: Sat, 18 Oct 2008 10:37:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: mauro.andreolini@unimore.it
Cc: linux-kernel@vger.kernel.org
Subject: Re: LatencyTop problem
Message-ID: <20081018103755.6ae73325@infradead.org>
In-Reply-To: <1224348558.7067.7.camel@localhost>
References: <1224348558.7067.7.camel@localhost>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008 18:49:18 +0200
Mauro Andreolini <mauro.andreolini@unimore.it> wrote:

> Hi everyone,
> 
> I tried to get latencytop (Debian testing package, v.0.4) running on a
> 2.6.27 vanilla kernel. When I try to execute latencytop as root, I get
> the following message:
> 
> Error writing to /proc/sys/kernel/latencytop: No such file or
> directory Error writing to /proc/sys/kernel/latencytop: No such file
> or directory Are you root?
> Please enable the CONFIG_LATENCYTOP configuration in your kernel.
> Exiting...
> 
> I am pretty sure that the CONFIG_LATENCYTOP is set in the kernel.

I just tried, and the file exists just fine for me... I think there's
something weird going on with your kernel, like you might not be
running the kernel you thought you were running...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
