Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZHTIoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZHTIoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZHTIog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:44:36 -0400
Received: from solitude.tty.gr ([95.154.208.37]:47066 "EHLO mx.tty.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbZHTIof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:44:35 -0400
Message-ID: <4A8D0BFC.7030101@debian.org>
Date: Thu, 20 Aug 2009 11:40:28 +0300
From: Faidon Liambotis <paravoid@debian.org>
Organization: Debian
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Matt Domsch <Matt_Domsch@dell.com>
CC: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       bero@arklinux.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 14003] New: Infinite loop on bootup while handling
 DMAR
References: <bug-14003-10286@http.bugzilla.kernel.org/>	 <20090819142634.0fc550d1.akpm@linux-foundation.org> <1250754748.8974.17.camel@macbook.infradead.org>
In-Reply-To: <1250754748.8974.17.camel@macbook.infradead.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Wed, 2009-08-19 at 14:26 -0700, Andrew Morton wrote:
>>> http://bugzilla.kernel.org/show_bug.cgi?id=14003
>>>            Summary: Infinite loop on bootup while handling DMAR
>> That's a box-killing post-2.6.30 regression.
> 
> It's a BIOS bug -- the user's BIOS is written by idiots who obviously
> shipped it without any QA whatsoever.
Matt may be wondering why he was addressed, since the bugzilla entry
mentions only a bug in HP's BIOS.

I'm experiencing the same bug on a newly bought Dell Optiplex 760 with
BIOS version A03, as explained in my mail in lkml,
<4A89CB52.4030008@debian.org>, subject "[regression, bisected] fails to
boot on Dell Optiplex 760 with VT-d enabled".

Thanks,
Faidon
