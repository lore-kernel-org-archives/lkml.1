Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZLHJwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZLHJwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZLHJwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:52:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZLHJwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:52:44 -0500
Message-ID: <4B1E229D.3030505@redhat.com>
Date: Tue, 08 Dec 2009 17:55:41 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] selinux: remove a useless return
References: <20091203085127.4370.1737.sendpatchset@localhost.localdomain> <alpine.LRH.2.00.0912080925340.21327@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.0912080925340.21327@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris wrote:
> On Thu, 3 Dec 2009, Amerigo Wang wrote:
> 
>> The last return is unreachable, remove the 'return'
>> in default, let it fall through.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Eric Paris <eparis@parisplace.org>
> 
> 
> Applied to
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> 
> with a fixup for the problem reported by Dan Carpenter.
> 
> You should not send out patches without testing them, even when following 
> the advice of the person you're sending them to :-)
> 

Right, will be careful, thank you!

