Return-Path: <linux-kernel-owner+w=401wt.eu-S938692AbXHIE55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938692AbXHIE55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 00:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbXHIE5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 00:57:50 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:60984 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbXHIE5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 00:57:49 -0400
Date: Thu, 9 Aug 2007 07:57:43 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: early boot lockup with 2.6.23-rc1
Message-ID: <20070809045743.GA2342@nalle>
References: <20070808223120.GA2286@nalle> <20070808170211.4401c019.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070808170211.4401c019.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 05:02:11PM -0700, Andrew Morton wrote:
> On Thu, 9 Aug 2007 01:31:20 +0300
> Mikko Rapeli <mikko.rapeli@iki.fi> wrote:
> 
> > Since 2.6.23-rc1 I can't boot an old k6 (with a funky IDE drive worth testing
> > with libata). The boot hangs without a sound or letter prints on the
> > screen right after grub, while 2.6.22.1 works fine.
> 
> Try adding the `earlyprintk=vga' parameter to the kernel command line?

Tried but didn't see anything. I'll try some git snapshots...

-Mikko
