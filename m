Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbYGTK5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbYGTK5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 06:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYGTK51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 06:57:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57717 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbYGTK50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 06:57:26 -0400
Date: Sun, 20 Jul 2008 06:57:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Fred ." <eldmannen@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Please add ZFS support (from GPL sources)
Message-ID: <20080720105724.GA8921@infradead.org>
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com> <487FA143.9010109@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487FA143.9010109@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 03:45:07PM -0400, Jeff Garzik wrote:
> Fred . wrote:
>> Previously we have not been able to have ZFS support due to it being
>> licensed under the CDDL and the kernel under the GPL.
>>
>> Sun have contributed ZFS support to GRUB under the GPL license. We
>> could now use that code to implement support for ZFS in the Linux
>> kernel.
>>
>> http://blogs.sun.com/darren/entry/zfs_under_gplv2_already_exists
>
> Linux needs btrfs upstream more than it needs ZFS...

Don't be so harsh.  Adding a read-only for the start zfs driver for
Linux would be useful for various purposes.  And adding read-only
filesystems to Linux is really easy.  So if Fred really cares about it
I'd be very happy to mentor him implementing it.  IT should be a very
good learning exercise for him.
