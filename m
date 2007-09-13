Return-Path: <linux-kernel-owner+w=401wt.eu-S1758881AbXIMPCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881AbXIMPCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXIMPCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:02:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:41857 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbXIMPCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:02:22 -0400
Date: Thu, 13 Sep 2007 17:02:20 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: kexec@lists.infradead.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] Add extended crashkernel command line syntax
Message-ID: <20070913150220.GM26903@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	kexec@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20070909083914.065380136@strauss.suse.de> <20070911060913.GC5053@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911060913.GC5053@in.ibm.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-09-11 08:09]:
> 
> How often does this scenario happen? Anyway, if you run into these issues
> and if it helps, I don't mind additional command line syntax for crashkernel=

Of course, I agree, this is a rare case.

> > This series implements this change for i386, x86_64 and IA64. However, if
> > the patch is accepted, I can also add all other architectures that support
> > Kdump (when my grepping was correct, this is only PPC64 and SH in addition).
> > The "simple" syntax is of course still supported.
> 
> Please make the changes for ppc64 and sh too.

Thanks, done now. Patchset follows. It should address all issues
mentioned by you and others.


Thanks,
   Bernhard
