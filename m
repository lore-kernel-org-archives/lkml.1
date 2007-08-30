Return-Path: <linux-kernel-owner+w=401wt.eu-S1762551AbXH3PKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762551AbXH3PKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758344AbXH3PKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:10:06 -0400
Received: from styx.suse.cz ([82.119.242.94]:35334 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757950AbXH3PKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:10:05 -0400
Date: Thu, 30 Aug 2007 17:10:03 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
In-Reply-To: <8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz>
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz> 
 <8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com> 
 <Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz>
 <8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Mike Frysinger wrote:

> Blackfin too please :) i think v850 also falls into this category, but 
> i'm not terribly familiar with it ...

Andrew, do you still strongly oppose to having ARCH_HAS_RANDOMIZE_BRK 
macro instead please?

Thanks,

-- 
Jiri Kosina
SUSE Labs
