Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZCYW1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZCYW1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 18:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZCYW0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 18:26:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34616 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZCYW0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 18:26:55 -0400
Date: Wed, 25 Mar 2009 23:29:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Niel Lambrechts <niel.lambrechts@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: EXT4: __ext4_get_inode_loc errors after s2disk
Message-ID: <20090325222943.GA13371@elf.ucw.cz>
References: <49C941D5.1000509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C941D5.1000509@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-03-24 22:25:57, Niel Lambrechts wrote:
> Hi,
> 
> After upgrading to 2.6.29 I get the below errors after resuming from
> hibernating with s2disk. I ran fsck and tried doing the same thing again
> in 2.6.28.9-pae, but do not get any errors there.

what kind of disk/what kind of controller is that?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
