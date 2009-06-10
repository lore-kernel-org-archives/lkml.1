Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbZFJLfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbZFJLfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754539AbZFJLfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:35:00 -0400
Received: from www.tglx.de ([62.245.132.106]:38992 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZFJLfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:35:00 -0400
Date: Wed, 10 Jun 2009 13:34:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rakib Mullick <rakib.mullick@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, yhlu.kernel@gmail.com,
       "H. Peter Anvin" <hpa@zytor.com>, macro@linux-mips.org,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v2: x86,APIC: Detect lapic_is_integrated() once - use
 on and on
In-Reply-To: <b9df5fa10906100424h98862a8l32951906d06454fb@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0906101333350.3351@localhost.localdomain>
References: <b9df5fa10905251820l3783327ek4f6b7014aa167690@mail.gmail.com>  <86802c440905251911h6f6c146eo4c30d306ac8d17d8@mail.gmail.com>  <b9df5fa10905261949j3eb4dc9ft321dba3c46c335db@mail.gmail.com>
 <b9df5fa10906100424h98862a8l32951906d06454fb@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jun 2009, Rakib Mullick wrote:

> Hi Ingo, Thomas and everyone, would you please take a look at this
> patch and comment ? I think Thomas was agreed with this one. Is there
> anything that i couldn't deliver? If i'm wrong please notice thus i
> can fix myself.

The patch is fine, but it lacks a proper patch description.

Thanks,

	tglx
