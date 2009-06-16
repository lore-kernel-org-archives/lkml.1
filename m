Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbZFPQhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbZFPQhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 12:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756114AbZFPQg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 12:36:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37072 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751866AbZFPQg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 12:36:58 -0400
Date: Tue, 16 Jun 2009 17:38:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: <braddo@tranceaddict.net>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: PAT support (or lack of) for Pentium 3 CPU's
Message-ID: <20090616173817.3956e220@lxorguk.ukuu.org.uk>
In-Reply-To: <20090616080904.CCA17C3A@resin11.mta.everyone.net>
References: <20090616080904.CCA17C3A@resin11.mta.everyone.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009 08:09:04 -0700
"Brad Allen" <braddo@tranceaddict.net> wrote:

> It has come to my attention that PAT support has been disabled for P3 CPU's in kernel versions 2.6.30 and later due to a bug in the CPU. 
> 
> I have attempted to get the NVIDIA proprietary drivers working with these kernel versions and 3 different Pentium 3 motherboards, all have failed. The drivers seem to require PAT support in order to work correctly, each board has in fact produced a different error when using only MTRR.
> 
> Can a kernel option be added to enable/disable PAT for P3 CPU's? Or is there any possible workaround for the bug?

Please ask Nvidia for support on their proprietary products. Only they
have all the code.
