Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbZG2J4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbZG2J4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 05:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZG2J4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 05:56:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51231 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbZG2J4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 05:56:13 -0400
Message-ID: <4A701DD1.7000300@redhat.com>
Date: Wed, 29 Jul 2009 13:00:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH 0/7 v5] KVM: support for 1gb pages
References: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2009 05:30 PM, Joerg Roedel wrote:
> Hello,
>
> this is the latest version of the changes to KVM MMU code to support 1gb
> pages.  Pages with a size of 1gb are a feature of all Fam10h AMD CPUs
> and this patch set makes them available for guests and allows to map the
> nested page table with 1gb pages.
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

