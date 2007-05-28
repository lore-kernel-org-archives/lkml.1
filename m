Return-Path: <linux-kernel-owner+w=401wt.eu-S1759966AbXE1O5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966AbXE1O5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXE1O5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:57:35 -0400
Received: from ns1.suse.de ([195.135.220.2]:41937 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbXE1O5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:57:34 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH 1/2] x86_64: Reflect the relocatability of the kernel in the ELF header.
Date: Mon, 28 May 2007 16:57:26 +0200
User-Agent: KMail/1.9.6
Cc: vgoyal@in.ibm.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <m1slah6gm0.fsf@ebiederm.dsl.xmission.com> <20070501050657.GA23111@in.ibm.com> <20070528105442.GA25599@suse.de>
In-Reply-To: <20070528105442.GA25599@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281657.26292.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 12:54:42 Bernhard Walle wrote:
> * Vivek Goyal <vgoyal@in.ibm.com> [2007-05-01 07:06]:
> > This seems to be a problem with gdb 6.5. I transferred the dump to a
> > different machine having GNU gdb 6.4, and it works fine there.
> 
> What's the state of it? Andy, was the GDB breakage the reason why you
> didn't merge it? 

Yes, I was waiting for Vivek to figure that out.

-Andi
