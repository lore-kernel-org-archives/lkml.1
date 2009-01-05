Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZAEPB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZAEPB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZAEPAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:00:06 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:36707 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbZAEPAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:00:00 -0500
Date: Mon, 5 Jan 2009 14:59:56 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jike Song <albcamus@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.28 hates my RTC clock - with PM_TRACE set
Message-ID: <20090105145956.GA965@srcf.ucam.org>
References: <df9815e70901050619v6c60e8d4w6868759bb3c36bdb@mail.gmail.com> <20090105143338.GA32337@srcf.ucam.org> <df9815e70901050640k6f0527c5v4eae02ccb2295bc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df9815e70901050640k6f0527c5v4eae02ccb2295bc3@mail.gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 10:40:36PM +0800, Jike Song wrote:

> Thanks for you information! I took it for granted that the RTC clock
> will be restored after resume/reboot.
> 
> So it's only an ordinary S2R bug with a black screen?  I can't see
> anything with PM_TRACE.

The PM_TRACE output will be in the dmesg of the kernel when you boot 
immediately after tha hang.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
