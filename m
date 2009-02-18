Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbZBRXEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbZBRXEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZBRXEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:04:09 -0500
Received: from gw.goop.org ([64.81.55.164]:46779 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213AbZBRXEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:04:07 -0500
Message-ID: <499C93E1.20104@goop.org>
Date: Wed, 18 Feb 2009 15:04:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>,
       Alok N Kataria <akataria@vmware.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/9] Make lazy mmu update mode pre-empt safe
References: <cover.1234988621.git.jeremy.fitzhardinge@citrix.com> <cover.1234988621.git.jeremy.fitzhardinge@citrix.com> <499C9116.7000702@goop.org> <20090218225534.GA24717@elte.hu>
In-Reply-To: <20090218225534.GA24717@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Are you using "git format-patch" and "git send-email" ?

Yes.

>  Then 
> perhaps the --compose option to git-send-email is what you are 
> after?

I'm pre-editing the 0000-cover.patch - but it looks like its picking up 
the 0000-cover.patch~ file in preference to 0000-cover.patch.  I think.

    J
