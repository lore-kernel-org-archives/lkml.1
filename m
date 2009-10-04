Return-Path: <linux-kernel-owner+w=401wt.eu-S932110AbZJDS54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbZJDS54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 14:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757715AbZJDS5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 14:57:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55841 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbZJDS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 14:57:55 -0400
Date: Sun, 4 Oct 2009 20:56:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any interest in unreferenced header files throughout the tree?
Message-ID: <20091004185655.GB1378@ucw.cz>
References: <alpine.LFD.2.00.0909291906060.9535@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909291906060.9535@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-29 19:11:55, Robert P. J. Day wrote:
> 
>   with a minor tweak to one of my scripts, i can now identify all
> header files throughout the source tree that no one seems to be using,
> and i can generate that output broken down as usual by logical
> subdirectories.
> 
>   as a simple example, under fs/, there appears to be a single unused
> header file:
> 
>   fs/xfs/xfs_refcache.h
> 
> if there's interest, i can generate output for the entire tree and
> post it at the normal wiki location.

Better yet post it to the list.

And if there are headers that are unused now and were unused in
2.6.25... I guess you can just submit patch removing those.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
