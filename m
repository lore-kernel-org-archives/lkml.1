Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbYBDWFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbYBDWFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYBDWFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:05:33 -0500
Received: from ns2.suse.de ([195.135.220.15]:35268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYBDWFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:05:32 -0500
Date: Mon, 4 Feb 2008 13:38:51 -0800
From: Greg KH <gregkh@suse.de>
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>, Willy Tarreau <w@1wt.eu>,
       Adrian Bunk <bunk@kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: {2.6.22.y} CVE-2007-6434
Message-ID: <20080204213851.GA27405@suse.de>
References: <6101e8c40802041213y4f3cb310qaff40052ed18d5df@mail.gmail.com> <6101e8c40802041302l83b0b86n9646bdb9e820f6cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40802041302l83b0b86n9646bdb9e820f6cd@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 10:02:03PM +0100, Oliver Pinter wrote:
> sorry, drop this ..
> 
> 
> /usr/data/source/oliver/build/linux-2.6.22.y-rcX-stable/mm/mmap.c: In
> function 'do_brk':
> /usr/data/source/oliver/build/linux-2.6.22.y-rcX-stable/mm/mmap.c:1889:
> error: too many arguments to function 'security_file_mmap'
> make[6]: *** [mm/mmap.o] Error 1
> make[5]: *** [mm] Error 2

Please at least build test your patches before you send them to us...
:)

thanks,

greg k-h
