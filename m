Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYGGVW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYGGVW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbYGGVWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:22:50 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:39274 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756360AbYGGVWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:22:49 -0400
Subject: Re: [PATCH 00/05] x86: Unify TSC code for 32bit and 64bit.
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       the arch/x86 maintainers <x86@kernel.org>,
       Dan Hecht <dhecht@vmware.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1214937790.20191.29.camel@promb-2n-dhcp368.eng.vmware.com>
References: <1214937790.20191.29.camel@promb-2n-dhcp368.eng.vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Mon, 07 Jul 2008 14:22:48 -0700
Message-Id: <1215465768.32752.8.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 11:43 -0700, Alok Kataria wrote:
> Hey Ingo,
> 
> Here is the patchset which merges the tsc code.
> 
> I have tried to divide the patchset in terms of merging a functionality
> at a time. I have tried to make the individual patches as independent as
> possible. From bisectability  point of view each patchset should compile
> and run individually as well. 
> 
> These patches are based on the current tip/master tree. 
> I have tested with around 10 randconfig for each i386 and x86_64.
> 
> Please have a look.

Hi Ingo, Thomas,

Please let me know if there are any comments on these patches.
If they seem fine can we start a tip/x86/unify-tsc, for wider testing.

Thanks,
Alok
> 
> Thanks,
> Alok
> 

