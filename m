Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521Ab0ATRPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab0ATRPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 12:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446Ab0ATRPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 12:15:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab0ATRPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 12:15:42 -0500
Message-ID: <4B573A36.9090308@redhat.com>
Date: Wed, 20 Jan 2010 19:15:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcelo Tosatti <mtosatti@redhat.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: linux-next: Tree for January 20 (kvm warnings)
References: <20100120181016.6ba3e504.sfr@canb.auug.org.au> <20100120091241.3f10428d.randy.dunlap@oracle.com>
In-Reply-To: <20100120091241.3f10428d.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 07:12 PM, Randy Dunlap wrote:
> On Wed, 20 Jan 2010 18:10:16 +1100 Stephen Rothwell wrote:
>
>    
>> Hi all,
>>
>> Changes since 20100119:
>>
>> The kvm tree lost its build failure.
>>      
>
> on i386/X86_32:
>
> arch/x86/kvm/x86.c:3810: warning: left shift count>= width of type
> arch/x86/kvm/x86.c:3812: warning: left shift count>= width of type
> arch/x86/kvm/x86.c:3814: warning: left shift count>= width of type
>
>    

Gleb already posted a patch to fix this.

-- 
error compiling committee.c: too many arguments to function

