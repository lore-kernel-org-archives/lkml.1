Return-Path: <linux-kernel-owner+w=401wt.eu-S1762582AbYDWDOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762582AbYDWDOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 23:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbYDWDOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 23:14:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45794 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbYDWDON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 23:14:13 -0400
Date: Wed, 23 Apr 2008 04:14:12 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS patches (second series)
Message-ID: <20080423031412.GX27459@ZenIV.linux.org.uk>
References: <20080423002219.GW27459@ZenIV.linux.org.uk> <alpine.LFD.1.10.0804221854460.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804221854460.2779@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 06:56:25PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 23 Apr 2008, Al Viro wrote:
> > 
> > 	There will be probably 3 or 4 more series in this cycle - this
> > is not the last one...
> 
> Btw, your last series introduced a warning (fs/xattr.c - unused 'out_fput' 
> label), so I'm hoping that one has some reason for it? Or can we just get 
> that thing removed?

	The latter; will do in the next batch.
