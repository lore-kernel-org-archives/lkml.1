Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYJIS3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYJIS3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYJIS3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:29:04 -0400
Received: from sous-sol.org ([216.99.217.87]:33875 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750878AbYJIS3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:29:03 -0400
Date: Thu, 9 Oct 2008 11:28:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Cihula, Joseph" <joseph.cihula@intel.com>, linux-kernel@vger.kernel.org,
       "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: Re: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Message-ID: <20081009182809.GE6912@sequoia.sous-sol.org>
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com> <48EE3E71.8010604@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48EE3E71.8010604@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Cihula, Joseph wrote:
>> --- a/security/Kconfig	Mon Oct 06 12:50:47 2008 -0700
>> +++ b/security/Kconfig	Tue Oct 07 00:13:02 2008 -0700
>> @@ -115,6 +115,23 @@ config SECURITY_DEFAULT_MMAP_MIN_ADDR
>>  	  /proc/sys/vm/mmap_min_addr tunable.
>>   +config TXT
>
> This should be X86_TXT; perhaps even X86_INTEL_TXT unless someone else  
> is likely to implement this stuff.  ("TXT" is awfully generic.)

config NOTEPAD_EXE? (sorry, couldn't resist ;-)

Is there anything for ia64?
