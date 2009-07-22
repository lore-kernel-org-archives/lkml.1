Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZGVO31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZGVO31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZGVO30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:29:26 -0400
Received: from www.tglx.de ([62.245.132.106]:42788 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbZGVO3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:29:25 -0400
Date: Wed, 22 Jul 2009 16:29:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bastian Blank <bastian@waldi.eu.org>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] x86: detect use of extended APIC ID for AMD CPUs
In-Reply-To: <20090722095436.GA9000@wavehammer.waldi.eu.org>
Message-ID: <alpine.LFD.2.00.0907221628110.2813@localhost.localdomain>
References: <20090604104016.GT5736@alberich.amd.com> <20090721103642.GA10071@wavehammer.waldi.eu.org> <4A65F34D.40506@goop.org> <20090722095436.GA9000@wavehammer.waldi.eu.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, Bastian Blank wrote:

> On Tue, Jul 21, 2009 at 09:56:45AM -0700, Jeremy Fitzhardinge wrote:
> > Does this work?  (Completely untested.)
> 
> Yes, it works. It just looks like a workaround.

No, it looks fine. Jeremy, can you please send it again with a proper
changelog.

Thanks,

	tglx
