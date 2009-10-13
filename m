Return-Path: <linux-kernel-owner+w=401wt.eu-S1759664AbZJMMbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664AbZJMMbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbZJMMbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:31:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbZJMMbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:31:38 -0400
Message-ID: <4AD4730C.9010305@redhat.com>
Date: Tue, 13 Oct 2009 15:31:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow userspace to adjust kvmclock offset
References: <1254849896-3947-1-git-send-email-glommer@redhat.com> <4AD2EE86.50807@redhat.com> <20091013122828.GZ8092@mothafucka.localdomain>
In-Reply-To: <20091013122828.GZ8092@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 03:28 PM, Glauber Costa wrote:
>
>> Do we want an absolute or relative adjustment?
>>      
> What exactly do you mean?
>    

Absolute adjustment: clock = t
Relative adjustment: clock += t


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

