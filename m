Return-Path: <linux-kernel-owner+w=401wt.eu-S1030945AbXEDP7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030945AbXEDP7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030995AbXEDP7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:59:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030945AbXEDP7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:59:14 -0400
Date: Fri, 4 May 2007 08:58:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert
 "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
Message-Id: <20070504085818.2762b160.akpm@linux-foundation.org>
In-Reply-To: <1178289450.23670.100.camel@localhost.localdomain>
References: <m1mz0ku7je.fsf@ebiederm.dsl.xmission.com>
	<1178280770.23670.61.camel@localhost.localdomain>
	<m1y7k4smmo.fsf@ebiederm.dsl.xmission.com>
	<1178289450.23670.100.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 May 2007 00:37:30 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:

> Of course, I expect that Andrew is about to push my patches to Linus....
> any day now... right Andrew?  Then we don't need this argument.

It would be about a week off.  I'll resend the paches out for rereview.
