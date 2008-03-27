Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbYC0Jmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbYC0Jmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYC0Jmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:42:44 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:49913 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751065AbYC0Jmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:42:43 -0400
Date: Thu, 27 Mar 2008 10:42:24 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 27
Message-ID: <20080327104224.2b98b561@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080327183357.7c637aed.sfr@canb.auug.org.au>
References: <20080327183357.7c637aed.sfr@canb.auug.org.au>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2008 09:42:25.0318 (UTC) FILETIME=[DD059C60:01C88FEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 18:33:57 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Status of my local build tests is at
> http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

AVR32 allnoconfig found a bug, which I've fixed. Could you try enabling
it again?

Haavard
