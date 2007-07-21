Return-Path: <linux-kernel-owner+w=401wt.eu-S1764728AbXGUTNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764728AbXGUTNb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXGUTNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:13:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48960 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711AbXGUTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:13:22 -0400
Date: Sat, 21 Jul 2007 12:13:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "Andi Kleen" <ak@suse.de>, "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Greg KH" <gregkh@suse.de>, rdunlap@xenotime.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [broken-out-2007-07-20-00-22] kernel bug at kernel/params:570
Message-Id: <20070721121310.361fe9cc.akpm@linux-foundation.org>
In-Reply-To: <6bffcb0e0707211111g32684615k5d526be182b53cc@mail.gmail.com>
References: <6bffcb0e0707200932p2b905e21g7970172ca7eb4da7@mail.gmail.com>
	<a781481a0707210136l272fc4fauaf14afce4178d9e4@mail.gmail.com>
	<6bffcb0e0707210900h505f04aaq98e0f4b17139d94b@mail.gmail.com>
	<200707211841.39339.ak@suse.de>
	<6bffcb0e0707211111g32684615k5d526be182b53cc@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 20:11:16 +0200 "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> Yet another one:
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-07-20-00-22/00004.jpg
> it looks very weird ;)
> 
> Why "Linux 2/6/22-git14 #14 SMP..." banner is displayed 5 times?

Was that with the fixed x86_64-mm-i386-string-out-of-line.patch?

> Andrew, is this a known issue?

Nope.  But I haven't compiled all that stuff in over a week, let
alone tried to boot it.  I assumed everyone went by the announce
emails rather than autofishing in the upload directory ;)
