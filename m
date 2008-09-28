Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYI1Xq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYI1Xq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 19:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYI1XqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 19:46:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbYI1XqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 19:46:22 -0400
Date: Sun, 28 Sep 2008 19:46:16 -0400
From: Rik van Riel <riel@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
Subject: Re: [REQUEST] Clarification from Copyright Holders on
 FUSE/NDISWRAPPER
Message-ID: <20080928194616.10d25760@bree.surriel.com>
In-Reply-To: <20080928194536.GC8711@mit.edu>
References: <33521.166.70.238.43.1222622153.squirrel@webmail.wolfmountaingroup.com>
	<20080928194536.GC8711@mit.edu>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2008 15:45:36 -0400
Theodore Tso <tytso@mit.edu> wrote:

> The position statement on closed-source Linux Kernel Modules was
> deliberately not a "policy statement", nor did it talk about issues
> about what is or isn't legal.  This was deliberate.  Issues over
> whether or not the GPL covers binary modules fundamentally depend on
> individual legal jurisdictions' interpretations of copyright law and
> derivitive works, 

This, of course, means you may want to ask your lawyer to
make sure to which countries binary only kernel modules can
be distributed and in which countries they are definately
illegal.

Then you can put some access control in place on your web
site to make sure people from countries where binary only
kernel modules are illegal cannot download your drivers.

Of course, what to do with the countries where the answer
to the question is not clear cut is up to you...

Investigating a few hundred jurisdictions could be a fair
amount of work, but if you want to be absolutely sure there's
not much else you can do.

-- 
All rights reversed.
