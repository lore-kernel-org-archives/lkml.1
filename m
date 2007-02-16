Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbXBPIbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbXBPIbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 03:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXBPIbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 03:31:38 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:39932 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbXBPIbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 03:31:38 -0500
Message-ID: <45D56BE9.2070703@vmware.com>
Date: Fri, 16 Feb 2007 00:31:37 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ian Campbell <Ian.Campbell@XenSource.com>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Ian Pratt <ian.pratt@XenSource.com>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and disable
 unsupported config options.
References: <20070216022449.739760547@goop.org>	<20070216022531.570154735@goop.org> <45D54BFF.80100@vmware.com>	<m11wkqimjd.fsf@ebiederm.dsl.xmission.com>	<1171613663.20666.30.camel@localhost.localdomain> <m1ire2h5n5.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ire2h5n5.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Ian Campbell <Ian.Campbell@XenSource.com> writes:
>
>   
>> On Fri, 2007-02-16 at 00:33 -0700, Eric W. Biederman wrote:
>>     
>>> I know there actually has been some work to get kexec actually working under
>>> Xen but I don't know where that has gone.
>>>       
>> kexec/kdump works with Xen 3.0.4 but it's a dom0 only thing so it
>> doesn't appear in this patchset.
>>     
>
> Ok but we still need to get the failure to user space for domU instead
> of trying what works on real hardware and failing.
>
> Eric

Acked-by: Zachary Amsden <zach@vmware.com>
