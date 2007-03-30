Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbXC3TeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbXC3TeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXC3TeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:34:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57107 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXC3TeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:34:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@suse.de>
Cc: Mitch Williams <mitch.a.williams@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.20.4] Flush MSI-X table writes (rev 3)
References: <1175281427.17652.16.camel@strongmad>
	<20070330190951.GA18351@suse.de>
Date: Fri, 30 Mar 2007 13:33:45 -0600
In-Reply-To: <20070330190951.GA18351@suse.de> (Greg KH's message of "Fri, 30
	Mar 2007 12:09:51 -0700")
Message-ID: <m1ejn6il0m.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:
>
> Sorry, but this isn't going to go into 2.6.20 any time soon as it
> doesn't fit the rules for the -stable tree.
>
> But I'll take an updated version for my pci tree to go to Linus after
> 2.6.21 is out.

Greg this does fix a bug that affects 2.6.21.  We have hardware in 2.6.21 that
is affected And it at least seems to meet the obviously correct
criteria.  So at least for 2.6.21 I think it is interesting.

Eric
