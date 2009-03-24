Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZCXGVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZCXGVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 02:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZCXGVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 02:21:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:38626 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbZCXGVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 02:21:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mtk4RG9YpYJ9US57i3A5EkUD5/2Dh8CSCH1zOoUeAOBpvHNo0b4eavEzk5MGr8duKw
         SIX7u7FWdc5CAoI5u96ydgGH2xON1frY2zPHozQYPxNiTuhrXfe48H3UM+201oLmg2Ne
         rXoTWomNIahAkrE1W3MXBix4+Iy9rQ/skTOXQ=
Date: Tue, 24 Mar 2009 15:21:06 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH -tip 1/2] mm: introduce debug_kmap_atomic
Message-ID: <20090324062106.GA5327@localhost.localdomain>
References: <20090311143317.GA22244@localhost.localdomain> <tip-dd63fdcc63f0f853b116b52e56200a0e0227cf5f@git.kernel.org> <20090314041948.GA3697@localhost.localdomain> <20090314131555.GB17727@elte.hu> <20090322172333.7d7fde92.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090322172333.7d7fde92.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 22, 2009 at 05:23:33PM -0700, Andrew Morton wrote:
> I really don't know what's going on here.

Theare are two patches from me in -tip:
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=bb6d59ca927d855ffac567b35c0a790c67016103
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=dd63fdcc63f0f853b116b52e56200a0e0227cf5f

which may break -mmotm patches from me:
introduce-debug_kmap_atomic.patch
use-debug_kmap_atomic.patch

So please feel free to drop them if they cannot be applied.
I'll resubmit them in that case.
