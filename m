Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbXBYJ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbXBYJ60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 04:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXBYJ60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 04:58:26 -0500
Received: from il.qumranet.com ([82.166.9.18]:35740 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbXBYJ6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 04:58:25 -0500
Message-ID: <45E15DBF.8000106@qumranet.com>
Date: Sun, 25 Feb 2007 11:58:23 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/6] KVM userspace interface updates for 2.6.21
References: <45DC8B6E.5050205@qumranet.com> <45DC8D97.9060408@qumranet.com>
In-Reply-To: <45DC8D97.9060408@qumranet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> The patchset, along with the previous fixset, is available as a git 
> tree from git://kvm.qumranet.com/home/avi/kvm/linux-2.6.  You may wish 
> to plant it in your little git forest.
>

This is now git://kvm.qumranet.com/home/avi/kvm.git, as a bare 'git 
pull' will pull the current branch instead of master, giving you 
whatever I was working on at the moment.  The kvm.git repo will always 
have 'master' as the current branch.


-- 
error compiling committee.c: too many arguments to function

