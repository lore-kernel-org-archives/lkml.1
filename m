Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYLHMAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYLHMAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 07:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYLHMAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 07:00:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYLHMAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 07:00:32 -0500
Message-ID: <493D0C5A.9030703@redhat.com>
Date: Mon, 08 Dec 2008 14:00:26 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] kvm: Extract core of kvm_flush_remote_tlbs/kvm_reload_remote_mmus.
References: <200812072125.14416.rusty@rustcorp.com.au> <493BF144.9080106@redhat.com> <200812082026.24350.rusty@rustcorp.com.au>
In-Reply-To: <200812082026.24350.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Avi said:
>   
>> Wow, code duplication from Rusty. Things must be bad.
>>     
>
> Something about glass houses comes to mind.  But instead, a patch.
>   

Er, right, eek.

I've applied all three patches, thanks.

-- 
error compiling committee.c: too many arguments to function

