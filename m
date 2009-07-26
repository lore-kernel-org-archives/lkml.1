Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZGZSST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZGZSST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbZGZSST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 14:18:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51297 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbZGZSSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 14:18:18 -0400
Message-ID: <4A6C9DE6.8080002@redhat.com>
Date: Sun, 26 Jul 2009 21:18:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: g3vbv@blueyonder.co.uk
CC: linux-kernel@vger.kernel.org, Sid Boyce <sboyce@blueyonder.co.uk>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: OpenSolaris boot failure with KVM and VirtualBox
References: <4A5ED714.7010304@blueyonder.co.uk> <4A6C80C3.8090007@redhat.com> <4A6C9D1F.3090404@blueyonder.co.uk>
In-Reply-To: <4A6C9D1F.3090404@blueyonder.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2009 09:14 PM, Sid Boyce wrote:
>
>> Is this a regression from previous kernel versions?  What userspace are
>> you using?
>>
>>      
>
> Currently running 2.6.31-rc4 with the original kqemu-1.4.0pre1 on
> openSUSE 11.2 Milestone 4 and it boots OK - a 200G disk image used.
> qemu-system-x86_64 -cdrom /ISO/osol-0906-ai-x86.iso -boot d
> /osol0906.qcow2 -smp 4 -m 500M&
>    

Wait, are you using kqemu or kvm?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

