Return-Path: <linux-kernel-owner+w=401wt.eu-S1423194AbXBUWUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423194AbXBUWUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 17:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423195AbXBUWUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 17:20:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:37211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423194AbXBUWUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 17:20:09 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch 00/21] 2.6.19-stable review
Date: Wed, 21 Feb 2007 23:19:38 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <20070221013619.GA30227@kroah.com> <20070221114737.a09be761.akpm@linux-foundation.org> <m1odnn1d7n.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1odnn1d7n.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702212319.38886.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> commit 2fb12a9bca5ad9aa6dcd2c639b4a7656a8843ef8
> Author: Eric W. Biederman <ebiederm@xmission.com>
> Date:   Tue Feb 13 13:26:25 2007 +0100
> 
>     [PATCH] x86-64: survive having no irq mapping for a vector

Putting that patch into stable would be a good idea, agreed.

-Andi
