Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbYJNLyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbYJNLyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 07:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYJNLxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 07:53:44 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:1190 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbYJNLxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 07:53:42 -0400
X-BigFish: VPS-34(zz1432R98dR4015M1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8Q913-01-L9U-01
Date: Tue, 14 Oct 2008 13:53:07 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Simon Holm =?iso-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix compile warning for !(ACPI && X86_IO_APIC)
	builds
Message-ID: <20081014115307.GB29183@alberich.amd.com>
References: <1223938850.21717.21.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1223938850.21717.21.camel@odie.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Oct 2008 11:53:29.0878 (UTC) FILETIME=[79B1FB60:01C92DF3]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 01:00:50AM +0200, Simon Holm Thøgersen wrote:
> This fixes the following compile warning for !(ACPI && X86_IO_APIC) builds:
> 
> arch/x86/kernel/early-quirks.c:99: warning: 'ati_ixp4x0_rev' defined
> but not used

Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>


Makes sense.

Thanks,

Andreas


