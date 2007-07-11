Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbXGKWGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbXGKWGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763750AbXGKWGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:06:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763027AbXGKWGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:06:40 -0400
Message-ID: <46955465.8080207@redhat.com>
Date: Wed, 11 Jul 2007 18:06:29 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KVM Updates for 2.6.23-rc1
References: <11841377191653-git-send-email-avi@qumranet.com>
In-Reply-To: <11841377191653-git-send-email-avi@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2007 03:08 AM, Avi Kivity wrote:
> Linus, please do your usual thing from the repository and branch at
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus
> 
> This contains kvm updates for the 2.6.23 merge window, including
> 
>  - performance improvements
>  - suspend/resume fixes
>  - guest smp
>  - random fixes and cleanups
> 

What version of KVM does this update contain? I can't find any place
in the code with version number.
