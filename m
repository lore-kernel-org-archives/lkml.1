Return-Path: <linux-kernel-owner+w=401wt.eu-S934077AbYDWB4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077AbYDWB4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 21:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbYDWB43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 21:56:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393AbYDWB42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 21:56:28 -0400
Date: Tue, 22 Apr 2008 18:56:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS patches (second series)
In-Reply-To: <20080423002219.GW27459@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.10.0804221854460.2779@woody.linux-foundation.org>
References: <20080423002219.GW27459@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Apr 2008, Al Viro wrote:
> 
> 	There will be probably 3 or 4 more series in this cycle - this
> is not the last one...

Btw, your last series introduced a warning (fs/xattr.c - unused 'out_fput' 
label), so I'm hoping that one has some reason for it? Or can we just get 
that thing removed?

		Linus
