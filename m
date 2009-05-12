Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZELNts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZELNts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZELNt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:49:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:52116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027AbZELNt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:49:28 -0400
Subject: Re: [PATCH -tip] x86: cpu/proc.c adding extended_cpuid_level for
 /proc/cpuinfo
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090512133950.GA15474@aftab>
References: <1242112482.3283.1.camel@localhost.localdomain>
	 <20090512133950.GA15474@aftab>
Content-Type: text/plain
Date: Tue, 12 May 2009 19:19:37 +0530
Message-Id: <1242136177.14832.0.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 15:39 +0200, Borislav Petkov wrote:
> Hi,
> 
> On Tue, May 12, 2009 at 12:44:42PM +0530, Jaswinder Singh Rajput wrote:
> > 
> > Here are 2 patches for adding new field extended_cpuid_level, please
> > choose PATCH whichever is more appropriate:
> > 
> > PATCH 1:
> > Subject: [PATCH] x86: cpu/proc.c adding extended_cpuid_level for /proc/cpuinfo
> > 
> > extended_cpuid_level also gives useful information like cpuid_level
> > and very useful for AMD processors.
> > 
> > Adding extended_cpuid_level in /proc/cpuinfo completes cpuid_level info.
> 
> and this is needed because... ?!
> 

why we need cpuid_level ?


