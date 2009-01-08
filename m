Return-Path: <linux-kernel-owner+w=401wt.eu-S1761498AbZAHRLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761498AbZAHRLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbZAHRL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:11:26 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51852 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754785AbZAHRLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:11:25 -0500
Date: Thu, 8 Jan 2009 18:11:18 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
In-Reply-To: <20090108165029.GA10951@infradead.org>
Message-ID: <Pine.LNX.4.64.0901081809340.25621@vixen.sonytel.be>
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>
 <20090108165029.GA10951@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009, Christoph Hellwig wrote:
> On Thu, Jan 08, 2009 at 04:48:51PM +0000, Phillip Lougher wrote:
> > Please consider pulling my linux-next branch
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git
> > 
> > The patches have been posted to LKML and linux-fsdevel over the last
> > couple of months and have been reviewed and changed as requested.
> > Diffstat below.
> > 
> > Squashfs is a compressed read-only filesystem. It compresses metadata
> > and data, and uses up to 1 MiB block sizes for greater compression.
> 
> That seems pretty fast for something only posted this week and not

The patches have been posted before last October, and the recent changes are
according to the review comments.

> even in -next.

Incorrect, as of next-20090106 ;-)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
