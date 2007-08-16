Return-Path: <linux-kernel-owner+w=401wt.eu-S1762535AbXHPOL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762535AbXHPOL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 10:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbXHPOLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 10:11:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:36999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759534AbXHPOLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 10:11:49 -0400
Message-ID: <46C45B22.5090701@suse.de>
Date: Thu, 16 Aug 2007 16:11:46 +0200
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
References: <1186990219.22431.37.camel@caritas-dev.intel.com>	 <20070815154245.500c572c.akpm@linux-foundation.org> <1187250664.15063.0.camel@caritas-dev.intel.com>
In-Reply-To: <1187250664.15063.0.camel@caritas-dev.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Huang, Ying wrote:
> On Thu, 2007-08-16 at 06:42 +0800, Andrew Morton wrote:
>> On Mon, 13 Aug 2007 15:30:19 +0800
>> "Huang, Ying" <ying.huang@intel.com> wrote:
>>
>>> Following sets of patches add EFI/UEFI (Unified Extensible Firmware
>>> Interface) runtime services support to x86_64 architecture.
>> I had to rework these a bit due to clashes with
>> x86_64-add-acpi-reboot-option.patch.  Please check carefully that
>> everything landed OK.
>>
> OK, I will be more careful next time.


Has the zero page documentation and version numbering project
made any progress? I think we cannot merge this without at least
the version number

-Andi
