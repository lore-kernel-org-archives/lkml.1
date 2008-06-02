Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYFBBGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYFBBGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 21:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYFBBG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 21:06:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbYFBBGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 21:06:25 -0400
Date: Sun, 1 Jun 2008 18:06:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: Diagnosing linux-next (Was: Re: m68k libc5 regression)
Message-Id: <20080601180616.75d1886e.akpm@linux-foundation.org>
In-Reply-To: <18499.16693.526974.912404@cargo.ozlabs.ibm.com>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
	<20080601005338.3affe880.akpm@linux-foundation.org>
	<20080601232638.fda1f3ab.sfr@canb.auug.org.au>
	<20080601140415.a2f25b9d.akpm@linux-foundation.org>
	<18499.16693.526974.912404@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 10:39:17 +1000 Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > hm, I just found the `committer' line in gitk.  Coulda sworn that
> > wasn't there yesterday.
> 
> It was, actually. :)
> 
> Seriously, if you have any suggestions about things that would make
> gitk more useful for you, let me know.
> 

tkdiff-style diff viewer!

I mentioned that to you a year or two back, and you've probabably
already done it but nobody told me about it :)
