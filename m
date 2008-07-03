Return-Path: <linux-kernel-owner+w=401wt.eu-S1761452AbYGCM61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761452AbYGCM61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbYGCM5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:57:45 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:48635 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081AbYGCM5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:57:44 -0400
X-Greylist: delayed 2595 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 08:57:44 EDT
Date: Thu, 3 Jul 2008 10:27:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [RFC PATCH 4/4] x86_32: mark ACPI NVS memory region
Message-ID: <20080703082720.GA4389@elte.hu>
References: <1215051879.5628.36.camel@rzhang-dt.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215051879.5628.36.camel@rzhang-dt.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang Rui <rui.zhang@intel.com> wrote:

> 
> x86_32: Mark ACPI NVS memory region.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> ---
>  arch/x86/kernel/e820_32.c |   26 ++++++++++++++++++++++++++

please do this change against tip/master or linux-next, as this file has 
been heavily modified and unified already. See:

 http://people.redhat.com/mingo/tip.git/README

	Ingo
