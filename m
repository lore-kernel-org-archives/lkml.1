Return-Path: <linux-kernel-owner+w=401wt.eu-S1758049AbZFLMHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049AbZFLMHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZFLMGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:06:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58174 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752708AbZFLMGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:06:53 -0400
Date: Fri, 12 Jun 2009 13:07:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kmemleak: Remove the kmemleak.h include in
 drivers/char/vt.c
Message-ID: <20090612130751.11410571@lxorguk.ukuu.org.uk>
In-Reply-To: <20090612095544.14809.74717.stgit@pc1117.cambridge.arm.com>
References: <1244800406.26670.29.camel@pc1117.cambridge.arm.com>
	<20090612095544.14809.74717.stgit@pc1117.cambridge.arm.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 10:55:44 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> This file is no longer annotated for false positives but the kmemleak.h
> include was still present.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Alan Cox <alan.cox@linux.intel.com>
