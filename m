Return-Path: <linux-kernel-owner+w=401wt.eu-S1764864AbXF1R2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764864AbXF1R2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbXF1R16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:27:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56660 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810AbXF1R16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:27:58 -0400
Message-ID: <4683EF87.1050303@redhat.com>
Date: Thu, 28 Jun 2007 13:27:35 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Bill Davidsen <davidsen@tmr.com>, Andi Kleen <andi@firstfloor.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>	 <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com>	 <p731wfy5m74.fsf@bingen.suse.de>  <4683BD56.7070707@tmr.com> <1183039975.14676.12.camel@laptopd505.fenrus.org>
In-Reply-To: <1183039975.14676.12.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 10:12 AM, Arjan van de Ven wrote:
> (while I work for Intel this is not an official Intel statement, but
> there is so much FUD going around now that I feel I need to at least
> point out a few things others "forget")
>> Slashdot carried an article this morning saying that an error in Intel 
>> microcode was being fixed.
> 
> don't just always believe everything you read on slashdot please
> 
>>  However, it listed only Windows related sites 
>> for the "fix" download. Is this the same TLB issue? And are these really 
>> fixes for Windows to flush the TLB properly the way Linux does?
> 
> First of all, Linux has microcode updates as well. Some of the more
> hypish news-bulletins just conveniently "forgot" about this. Basically
> all distributions ship them, so users who use the distro update tools
> get these automatically. And the update mentioned has been shipping for
> a while (in version 1.17).
> 

Fedora 6 has version 1.13
Fedora 7 also has 1.13
RHEL 5 has 1.15
Debian stable has 1.15 (9 Oct 2006)
Suse 10.1 has 1.13


