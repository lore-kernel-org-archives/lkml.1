Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbZDWXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbZDWXIn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756281AbZDWXIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:08:30 -0400
Received: from vena.lwn.net ([206.168.112.25]:46364 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758820AbZDWXI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:08:29 -0400
Date: Thu, 23 Apr 2009 17:08:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, tytso@mit.edu
Subject: Re: [PATCH] documentation: list common guidelines for commit log
 content
Message-ID: <20090423170827.47618b4e@bike.lwn.net>
In-Reply-To: <1239908456-24871-1-git-send-email-paul.gortmaker@windriver.com>
References: <1239908456-24871-1-git-send-email-paul.gortmaker@windriver.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009 15:00:56 -0400
Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Recent discussions on lkml have brought to light that it is
> probably worthwhile documenting some of the common (yet up to
> now implicit) requirements that exist for commit log content.
> This is by no means exhaustive, but it is a start.

Sorry I sat on this for a week; I've not ignored it.

The change made me uncomfortable, despite the fact that I didn't really
disagree with anything in it.  I guess I feel that there's only so far
that it makes sense to go with big long lists of do's and don't's.
That document is plenty long already...  So I put together something
shorter which tries to focus on the problem at a higher level.  

But maybe others disagree?

Thanks,

jon
