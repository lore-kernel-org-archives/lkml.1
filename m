Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbXDVFwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbXDVFwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 01:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbXDVFwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 01:52:55 -0400
Received: from mtaout4.012.net.il ([84.95.2.10]:21313 "EHLO mtaout4.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbXDVFwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 01:52:54 -0400
Date: Sun, 22 Apr 2007 08:52:39 +0300
From: Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [GIT PULL] kvm oops fix
In-reply-to: <9c21eeae0704192154r5abec14ax242f9c40bab09728@mail.gmail.com>
To: David Brown <dmlb2000@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-id: <462AF827.6020006@qumranet.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
X-Greylist: Sender IP whitelisted,
 not delayed by milter-greylist-2.1.12 (firebolt.argo.co.il [0.0.0.0]); Sun,
 22 Apr 2007 08:52:39 +0300 (IDT)
References: <1176997839110-git-send-email-avi@qumranet.com>
 <9c21eeae0704192154r5abec14ax242f9c40bab09728@mail.gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brown wrote:
> On 4/19/07, Avi Kivity <avi@qumranet.com> wrote:
>> Linus,
>>
>> Please pull from the 'linus' branch of
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git
>>
>> To get a one-liner fixing a host oops running  non-pae guests.
>>
>> Avi Kivity (1):
>>       KVM: Fix off-by-one when writing to a nonpae guest pde
>
> Ooo I thought of something else.
> Should this be applied to the current 2.6.20.7 for the next 2.6.20.8
> release?
>

Yes.  I'll prepare a patch.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

