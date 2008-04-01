Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbYDACOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbYDACOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 22:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYDACOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 22:14:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:20077 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYDACON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 22:14:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=WNbCiuLgC7k78L3ar38E34xd74MuBudjfyGuak+Gv3qGPUAmPDIyPlMbe0FEhPlC4ocO/c2LuD0XIk0AxZmIDfdyLyCT3I4HtEEoPjXOO1+aFdr2nqyx50Q5AXwYg1dcGIKL72JEq8dR/HlYb+lIPxtp/N1bFV0s5o8pXDdX1+E=
Date: Tue, 01 Apr 2008 10:11:29 +0800 (CST)
Message-Id: <20080401.101129.90822580.xiyou.wangcong@gmail.com>
To: davidn@davidnewall.com
Cc: warthog9@kernel.org, users@kernel.org, linux-kernel@vger.kernel.org,
       ftpadmin@kernel.org, mirror-list-d@redhat.com, suse-mirror@suse.de,
       centos-mirror@centos.org, mirror-list@redhat.com, hands@isc.org,
       support@osuosl.org, git@vger.kernel.org
Subject: Re: Kernel.org Downtime Notice - Please read *very* important
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <47F19460.7010206@davidnewall.com>
References: <47F1895D.7090509@kernel.org>
	<47F19460.7010206@davidnewall.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Newall <davidn@davidnewall.com>
Date: Tue, 01 Apr 2008 12:18:16 +1030

> J.H. wrote:
> > we are upgrading the kernel.org machines from Fedora Core 5 to FreeBSD
> > 7.0.
> 
> Highly commendable.  You should take this opportunity to also upgrade
> network facilities to meet the requirements as laid out in RFC1149 (CPIP).

What about RFC1606? Maybe kernel should include a net/ipv9 branch.
;-)
