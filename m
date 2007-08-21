Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbXHUKmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbXHUKmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 06:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758742AbXHUKmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 06:42:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbXHUKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 06:41:59 -0400
Message-ID: <46CAC168.7090102@zytor.com>
Date: Tue, 21 Aug 2007 03:41:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com> <20070815154245.500c572c.akpm@linux-foundation.org> <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de> <1187313920.28497.1.camel@caritas-dev.intel.com> <46C5C8C4.4060407@zytor.com> <1187580031.27947.67.camel@caritas-dev.intel.com> <46C9CB89.7020603@zytor.com> <20070821113310.GF32640@bingen.suse.de>
In-Reply-To: <20070821113310.GF32640@bingen.suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> - "struct boot_params" (the zeropage) is kept as a legacy interface.
> 
> Legacy interface for what?  Just for kexec utils which never should
> have been using it anyways keeping backwards cruft around seems
> misplac.ed

Worse.  LinuxBIOS.  :(

	-hpa
