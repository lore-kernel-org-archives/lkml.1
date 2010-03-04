Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0CDAf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:35:57 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62495 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab0CDAfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:35:47 -0500
Message-ID: <4B8F0057.1020703@codemonkey.ws>
Date: Wed, 03 Mar 2010 18:35:35 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka NPT-Virtualization)
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 01:12 PM, Joerg Roedel wrote:
> Hi,
>
> here are the patches that implement nested paging support for nested
> svm. They are somewhat intrusive to the soft-mmu so I post them as RFC
> in the first round to get feedback about the general direction of the
> changes.  Nevertheless I am proud to report that with these patches the
> famous kernel-compile benchmark runs only 4% slower in the l2 guest as
> in the l1 guest when l2 is single-processor.

That's an awesome result.

Regards,

Anthony Liguori

