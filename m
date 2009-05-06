Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbZEFMV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbZEFMV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760030AbZEFMVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:21:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38139 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760018AbZEFMVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:21:44 -0400
Message-ID: <4A0180AB.20108@redhat.com>
Date: Wed, 06 May 2009 08:20:59 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, mingo@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH] x86: 46 bit PAE support
References: <20090505172856.6820db22@cuia.bos.redhat.com> <4A00ED83.1030700@zytor.com>
In-Reply-To: <4A00ED83.1030700@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Rik van Riel wrote:
>> Testing: booted it on an x86-64 system with 6GB RAM.  Did you really think
>> I had access to a system with 64TB of RAM? :)
> 
> No, but it would be good if we could test it under Qemu or KVM with an
> appropriately set up sparse memory map.

I don't have a system with 1TB either, which is how much space
the memmap[] would take...

-- 
All rights reversed.
