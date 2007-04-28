Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbXD1Kao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbXD1Kao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 06:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbXD1Kao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 06:30:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:46663 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245AbXD1K37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 06:29:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: fix PSE pagetable construction
Date: Sat, 28 Apr 2007 12:29:48 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <4632AE54.7030200@goop.org> <m1zm4tghyf.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1zm4tghyf.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704281229.48597.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> My preference would be for whoever had:
> paravirt_ops-hooks-to-set-up-initial-pagetable.patch

That would be very messy because there are many followup dependencies.

But once we have a good fix aggreed by everybody I can merge it into the 
initial patch then.


-Andi

