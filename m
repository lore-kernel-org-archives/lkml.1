Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbZJRC6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbZJRC6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 22:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZJRC6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 22:58:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:37510 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbZJRC6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 22:58:40 -0400
Message-ID: <4ADA845E.4080109@kernel.org>
Date: Sun, 18 Oct 2009 11:58:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       rostedt@goodmis.org, hpa@zytor.com, cebbert@redhat.com,
       tony.luck@intel.com
Subject: Re: [PATCH 13/16] percpu: remove per_cpu__ prefix.
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <4AD6EA57.6020105@kernel.org> <4AD80CD6.7030204@monstr.eu>
In-Reply-To: <4AD80CD6.7030204@monstr.eu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Oct 2009 02:58:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sorry about the delay.

Michal Simek wrote:
> where is git repo with that patches?

The patches are available in the following git tree.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git unified-symbols

and the original thread at

 http://thread.gmane.org/gmane.linux.kernel/902383

Thanks.

-- 
tejun
