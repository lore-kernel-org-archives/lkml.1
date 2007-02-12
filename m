Return-Path: <linux-kernel-owner+w=401wt.eu-S1030572AbXBMAZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030572AbXBMAZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030582AbXBMAZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:25:27 -0500
Received: from mga06.intel.com ([134.134.136.21]:34098 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030572AbXBMAZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:25:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,160,1170662400"; 
   d="scan'208"; a="195981330:sNHT68303585"
Date: Mon, 12 Feb 2007 15:51:12 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21 review I] [11/25] x86: default to physical mode on hotplug CPU kernels
Message-ID: <20070212155112.C15718@unix-os.sc.intel.com>
References: <200702101250.142420000@suse.de> <20070210115023.D19ED13DCE@wotan.suse.de> <m1vei9ymkh.fsf@ebiederm.dsl.xmission.com> <200702122336.23826.andi@firstfloor.org> <m1k5ynug3v.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
In-Reply-To: <m1k5ynug3v.fsf@ebiederm.dsl.xmission.com>; from ebiederm@xmission.com on Mon, Feb 12, 2007 at 04:10:44PM -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 04:10:44PM -0700, Eric W. Biederman wrote:
> Basically as I commented in genapic_flat, that at least on hyperthreading
> cpus the destination mask is not always honored, and so if you only
> allow one hyperthread I have seen the irq show up on the other hyperthread.

Which platform is this? I haven't heard this before.

thanks,
suresh
