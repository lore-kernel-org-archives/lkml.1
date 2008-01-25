Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYAYNT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYAYNT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:19:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbYAYNTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:19:20 -0500
Received: from tomts22.bellnexxia.net ([209.226.175.184]:35353 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753602AbYAYNTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:19:19 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FACBxmUdMQWYq/2dsb2JhbACBV6xy
Date: Fri, 25 Jan 2008 08:14:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch 07/26] Add INIT_ARRAY() to kernel.h
Message-ID: <20080125131411.GA20299@Krystal>
References: <20080124202706.250598537@polymtl.ca> <20080124203335.082459062@polymtl.ca> <20080124125845.bf5767b8.randy.dunlap@oracle.com> <20080124210431.GA1647@Krystal> <47991989.8060205@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <47991989.8060205@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:13:46 up 82 days, 18:19,  3 users,  load average: 0.16, 0.32,
	0.34
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>> Try opening such code in vim, and the syntax highlighting gets all
>> messed up :-/
>> The other option is to do the *right thing* and fix vim, of course, but
>> this change won't be in distros for a while.
>
> Let's get this straight...
>
> You're suggesting introducing a pointless, ugly macro into the kernel 
> because of a vim bug?
>
> *Plonk!*
>

heh, yup, I guess we should drop this patch. As you point out, it makes
no sense.

Mathieu

> 	-hpa

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
