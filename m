Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbZENBko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbZENBko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 21:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZENBkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 21:40:33 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:45998 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbZENBkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 21:40:32 -0400
Date: Thu, 14 May 2009 11:40:32 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm@vger.kernel.org, avi@redhat.com,
       aarcange@redhat.com, chrisw@redhat.com, mtosatti@redhat.com,
       hugh@veritas.com
Subject: Re: [PATCH 5/5] add ksm kernel shared memory driver.
Message-ID: <20090514014032.GX16602@bilbo.ozlabs.org>
Mail-Followup-To: Izik Eidus <ieidus@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, avi@redhat.com, aarcange@redhat.com,
	chrisw@redhat.com, mtosatti@redhat.com, hugh@veritas.com
References: <1240191366-10029-1-git-send-email-ieidus@redhat.com> <1240191366-10029-2-git-send-email-ieidus@redhat.com> <1240191366-10029-3-git-send-email-ieidus@redhat.com> <1240191366-10029-4-git-send-email-ieidus@redhat.com> <1240191366-10029-5-git-send-email-ieidus@redhat.com> <1240191366-10029-6-git-send-email-ieidus@redhat.com> <20090513161739.d801ab67.akpm@linux-foundation.org> <4A0B6289.2000502@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A0B6289.2000502@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 03:15:05AM +0300, Izik Eidus wrote:

> Hi
>
> There is some way (script) that i can run that will allow compile this  
> code for every possible arch?

Segher Boessenkool has a tool for builing cross toolchains and the kernel
at git://git.infradead.org/users/segher/buildall.git  You can save
yourself some time (and pain) and use the built toolchains at:
	http://bakeyournoodle.com/cross

If there is any interest I can get these toolchains hosted on a faster machine
(say kernel.org)

Yours Tony
