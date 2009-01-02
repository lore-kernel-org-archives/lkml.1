Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZABRzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZABRzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757790AbZABRz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:55:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657AbZABRz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:55:28 -0500
Subject: Re: [PATCH] x86: nmi.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090102172439.GD6759@elte.hu>
References: <1230725102.3738.10.camel@jaswinder.satnam>
	 <20090102172439.GD6759@elte.hu>
Content-Type: text/plain
Date: Fri, 02 Jan 2009 23:23:22 +0530
Message-Id: <1230918802.8976.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-02 at 18:24 +0100, Ingo Molnar wrote:
> does this build fine on UP + IOAPIC ? asm/smp.h has some side-effects that 
> brings in certain APIC definitions.
> 

Yes, it works fine for me.

JSR


