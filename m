Return-Path: <linux-kernel-owner+w=401wt.eu-S1762829AbYEORy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762829AbYEORy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 13:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758015AbYEORyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 13:54:16 -0400
Received: from eazy.amigager.de ([213.239.192.238]:57536 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760879AbYEORyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 13:54:15 -0400
Date: Thu, 15 May 2008 19:54:13 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Problems with suspend and USB storage
Message-ID: <20080515175413.GA10910@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20080515163315.GA17779@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515163315.GA17779@nostromo.devel.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 12:33:15 -0400, Bill Nottingham wrote:

[...]

> Is there any way to get sane behavior out of suspend/resume with
> USB storage?

I use this since 2.6.18, with my /home, one swap partition and some
other partitions on a USB hard disk. However, I use LVM, what might be
a good idea as the device names doesn't matter in this case (just a
guess). I never had any such failure with suspend to disk and to RAM as
described above.

Regards,
Tino
