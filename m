Return-Path: <linux-kernel-owner+w=401wt.eu-S933792AbYEAXLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792AbYEAXLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbYEAXH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:07:57 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:42487 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbYEAXH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:07:56 -0400
Date: Fri, 2 May 2008 09:07:53 +1000
To: Badari Pulavarty <pbadari@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com, akpm@linux-foundation.org,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: powerpc boot regression
Message-ID: <20080501230753.GP20457@bakeyournoodle.com>
References: <20080429.231241.221824292.davem@davemloft.net> <20080501051304.GM20457@bakeyournoodle.com> <1209653507.27240.7.camel@badari-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1209653507.27240.7.camel@badari-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 07:51:47AM -0700, Badari Pulavarty wrote:
 
> I don't see the problem on my power5 machine. Can you send the
> config ? Is CONFIG_SPARSEMEM_VMEMMAP enabled ?

Yes.  I'm just using ppc64_defconfig.

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

