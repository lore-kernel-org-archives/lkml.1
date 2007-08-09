Return-Path: <linux-kernel-owner+w=401wt.eu-S936535AbXHIHyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936535AbXHIHyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760565AbXHIHx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:53:58 -0400
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:43593 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758869AbXHIHx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:53:58 -0400
Date: Thu, 9 Aug 2007 10:53:52 +0300
From: Mikko Rapeli <mikko.rapeli@iki.fi>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: early boot lockup with 2.6.23-rc1
Message-ID: <20070809075351.GC2342@nalle>
References: <20070808223120.GA2286@nalle> <46BAC14E.9040604@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BAC14E.9040604@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 12:25:02AM -0700, H. Peter Anvin wrote:
> So it's not printing "Uncompressing kernel... " at all?

Yes, nothing comes up. Machine responds to three-finger-salute and
numlock status can be changed, though.

> It might be an issue with the new setup code.  What happens if you
> append "vga=ask" to the kernel command line?

I'll try later today.

-Mikko
