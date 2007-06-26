Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXFZUWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXFZUWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbXFZUW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:22:29 -0400
Received: from gw.goop.org ([64.81.55.164]:36083 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758040AbXFZUW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:22:28 -0400
Message-ID: <46817551.9040800@goop.org>
Date: Tue, 26 Jun 2007 16:21:37 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 03/10] define ELF notes for adding to a boot image
References: <20070615004818.424726597@goop.org>	<20070615005012.882738673@goop.org>	<4672BC5B.1040502@zytor.com>	<4672C0FF.9080209@goop.org> <20070626131830.9a4d4ae6.akpm@linux-foundation.org>
In-Reply-To: <20070626131830.9a4d4ae6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Jeremy, I'll duck these patches for now, sorry.  Mainly on
> i-already-have-enough-x86-stuff grounds.
>   

That's fine.  I think it breaks x86-64 at the moment anyway.  And I 
haven't got much feedback about it.

> There's a bit of overlap between this work and git-newsetup, but nothing
> particularly serious-looking.
>   

Yes, I based it on the newsetup stuff in -mm, so there shouldn't be too 
much difference.

    J
