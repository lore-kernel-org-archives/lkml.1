Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbXHUKwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbXHUKwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083AbXHUKv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:51:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:58231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753345AbXHUKvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:51:55 -0400
Date: Tue, 21 Aug 2007 13:45:48 +0200
From: Andi Kleen <ak@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@suse.de>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
Message-ID: <20070821114548.GI32640@bingen.suse.de>
References: <1186990219.22431.37.camel@caritas-dev.intel.com> <20070815154245.500c572c.akpm@linux-foundation.org> <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de> <1187313920.28497.1.camel@caritas-dev.intel.com> <46C5C8C4.4060407@zytor.com> <1187580031.27947.67.camel@caritas-dev.intel.com> <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de> <46CAC168.7090102@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CAC168.7090102@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 03:41:44AM -0700, H. Peter Anvin wrote:
> Andi Kleen wrote:
> >> - "struct boot_params" (the zeropage) is kept as a legacy interface.
> > 
> > Legacy interface for what?  Just for kexec utils which never should
> > have been using it anyways keeping backwards cruft around seems
> > misplac.ed
> 
> Worse.  LinuxBIOS.  :(

Sigh. Perhaps it should be renamed AntiLinuxBios: it seems to be actively adverse.

-Andi
