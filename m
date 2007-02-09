Return-Path: <linux-kernel-owner+w=401wt.eu-S1946033AbXBIDFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946033AbXBIDFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 22:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946037AbXBIDFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 22:05:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946033AbXBIDFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 22:05:05 -0500
Date: Thu, 8 Feb 2007 19:05:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-Id: <20070208190502.f9303bff.akpm@linux-foundation.org>
In-Reply-To: <82e4877d0702081857u273df895n5df617a14da8caa0@mail.gmail.com>
References: <82e4877d0702081857u273df895n5df617a14da8caa0@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 21:57:50 -0500 "Parag Warudkar" <parag.warudkar@gmail.com> wrote:

> >x86-fix-vdso-mapping-for-aout-executables.patch
> >a.out executables are presently non-functional.  This patch needs more work.
> 
> I have a patch for x86 ready and tested and I should be able to get
> the full thing (x86, ppc, sh and x86_64) out over the weekend. (This
> time around I got rid of the CONFIG stuff used __attribute__((weak))
> as Andi suggested. Hopefully that's what you meant by more work?)
> 

Sounds good, thanks.
