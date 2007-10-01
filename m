Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbXJAWFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbXJAWFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbXJAWFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:05:11 -0400
Received: from main.gmane.org ([80.91.229.2]:48389 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbXJAWFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:05:10 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: kernel panics when SMP-booting on a Nexcom Peak 7220VL2G
Date: Mon, 1 Oct 2007 15:04:00 -0700
Organization: Linux Foundation
Message-ID: <20071001150400.6b393e70@freepuppy.rosehill>
References: <ee8d22b80710011435k9c62712v125935b1e2b8e8c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <ee8d22b80710011435k9c62712v125935b1e2b8e8c1@mail.gmail.com>
X-Newsreader: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007 16:35:11 -0500
"Luis Garcia-Vega" <luis.garciavega@gmail.com> wrote:

> Hi list,
> 
>  I'm getting kernel panics when I boot a pair of  Xeon 2.8GHz on a
> Nexcom PEAK 7220VL2G board (one of those system on a board setups).
> I'm running the stock Red Hat Enterprise 4.5 kernel.  I mentioned a
> pair, because the system boots fine with the Uniprocessor kernel.  I
> thought it could be a ACPI issue, but after a few days of trying
> different boot options, i was still getting errors.
> And without further ado, here's the serial port capture.
> 
> Linux version 2.6.9-55.ELsmp (brewbuilder@ls20-bc2-14.build.redhat.com)
> (gcc version 3.4.6 20060404 (Red Hat 3.4.6-3)) #1 SMP Fri Apr 20
> 17:03:35 EDT 2007

Since you are using a vendor supplied kernel, you need to talk to
them.  2.6.9 is almost 3 years old.

