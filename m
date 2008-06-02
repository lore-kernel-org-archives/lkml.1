Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbYFBCMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbYFBCMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 22:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYFBCMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 22:12:37 -0400
Received: from ozlabs.org ([203.10.76.45]:58380 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbYFBCMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 22:12:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18499.22285.159342.856006@cargo.ozlabs.ibm.com>
Date: Mon, 2 Jun 2008 12:12:29 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: Diagnosing linux-next (Was: Re: m68k libc5 regression)
In-Reply-To: <20080601180616.75d1886e.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
	<Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
	<20080601005338.3affe880.akpm@linux-foundation.org>
	<20080601232638.fda1f3ab.sfr@canb.auug.org.au>
	<20080601140415.a2f25b9d.akpm@linux-foundation.org>
	<18499.16693.526974.912404@cargo.ozlabs.ibm.com>
	<20080601180616.75d1886e.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> tkdiff-style diff viewer!
> 
> I mentioned that to you a year or two back, and you've probabably
> already done it but nobody told me about it :)

There's now a facility for viewing diffs in an external viewer.  If
you do Edit->Preferences and set the "External diff tool" thing to
tkdiff, then you can right-click on a file name in the file list
(bottom right-hand pane) and select "External diff" and it will launch
tkdiff to show you the diffs for that file.

What is it you like about tkdiff?  Is it the side-by-side display, or
the highlighting of differences within a line, or the merge facility?

Paul.
