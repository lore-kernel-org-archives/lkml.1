Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZHCM2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZHCM2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZHCM2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:28:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35974 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915AbZHCM2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:28:48 -0400
Message-ID: <4A76D92B.1060807@redhat.com>
Date: Mon, 03 Aug 2009 15:33:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] kvm: fix kvm_init()
References: <4A76A96E.8070608@cn.fujitsu.com>
In-Reply-To: <4A76A96E.8070608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2009 12:10 PM, Xiao Guangrong wrote:
> Remove debugfs file if kvm_arch_init() return error
>
>    

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

