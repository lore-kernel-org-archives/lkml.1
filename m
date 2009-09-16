Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZIPCIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZIPCIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 22:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZIPCIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 22:08:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:62650 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZIPCIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 22:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,394,1249282800"; 
   d="scan'208";a="448864794"
Subject: Re: x86-PAT tree merge causes keyboard problems
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB018C0.30203@zytor.com>
References: <20090915205259.GA1910@phenom2.trippelsdorf.de>
	 <4AB018C0.30203@zytor.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 15 Sep 2009 19:07:39 -0700
Message-Id: <1253066859.2667.1.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 15:44 -0700, H. Peter Anvin wrote:
> We need more information about your system, the lspci -vv and dmidecode
> output, as well as your entire dmesg, and a dump of
> /debug/x86/pat_memtype_list.

I am able to reproduce similar such mem type conflict messages on my
system. Will look more detailed into this tomorrow.

thanks,
suresh

