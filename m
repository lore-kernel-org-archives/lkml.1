Return-Path: <linux-kernel-owner+w=401wt.eu-S1758173AbZGGQpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173AbZGGQpD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbZGGQox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:44:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41782 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbZGGQow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:44:52 -0400
Message-ID: <4A537C12.2040501@redhat.com>
Date: Tue, 07 Jul 2009 19:47:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v4] KVM support for 1GB pages
References: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1246984867-15952-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2009 07:41 PM, Joerg Roedel wrote:
> Hi,
>
> this is the forth version of the patches for KVM to support 1GB pages.
> This code still only can make use of 1GB pages with nested paging
> enabled. I will give the shadow paging code another debug round soon.
> Please comment or consider to apply these patches.
>
>    

I would really like to have shadow 1GB work, or at least gain some 
understanding of why it doesn't.

Can you detail the changes compared to the previous round?

-- 
error compiling committee.c: too many arguments to function

