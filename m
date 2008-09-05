Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYIEOGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYIEOGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYIEOGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:06:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbYIEOG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:06:29 -0400
Message-ID: <48C13CB6.4010506@redhat.com>
Date: Fri, 05 Sep 2008 10:05:42 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efifb/imacfb consolidation + hardware support
References: <48C001EC.3040205@redhat.com> <20080904171006.3698819b.akpm@linux-foundation.org>
In-Reply-To: <20080904171006.3698819b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
> 
> uh-oh.
> 
> On Thu, 04 Sep 2008 11:42:36 -0400
> Peter Jones <pjones@redhat.com> wrote:
> 
>> Hi.  Below is a patch that removes imacfb entirely, merging its DMI
>> table into the (otherwise very similar) efifb driver.  This also adds
>> hardware support for many of the newer Intel Apple hardware.  This has
>> been fairly well tested; we've been shipping it in Fedora for some time.
>>
> 
> The patch was space-stuffed.  I fixed that.  Please see
> Documentation/email-clients.txt to fix it.

Thanks for the pointer.

> Please send a Signed-off-by: for this change.

I'll assume that in this response is fine:

Signed-off-by: Peter Jones <pjones@redhat.com>


-- 
         Peter
