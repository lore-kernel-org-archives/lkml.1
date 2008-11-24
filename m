Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYKXPAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYKXPAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYKXO7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 09:59:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50367 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYKXO7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 09:59:53 -0500
Date: Mon, 24 Nov 2008 12:58:32 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] x86: disable virt on kdump and emergency_restart
	(v4)
Message-ID: <20081124145832.GC16862@blackpad>
References: <1226955804-16802-1-git-send-email-ehabkost@redhat.com> <20081118081501.GF17838@elte.hu> <4926DCC8.1040500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4926DCC8.1040500@redhat.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 06:07:36PM +0200, Avi Kivity wrote:
<snip>
>
> Eduardo, please check the merge (there was a small conflict in reboot.c  
> which I fixed) once I push it.  Also, when generating patches that move  
> files, use the -M switch: this makes it easier to review, and also  
> handles files that change better.

The merge looks ok. I didn't know about -M, I will use it next time.

Thanks!

-- 
Eduardo
