Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYCPSWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYCPSWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 14:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYCPSWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 14:22:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:53758 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbYCPSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 14:22:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NwtCvxmK0m8baU+4UCtPqsnY8LwTgRsB0raYQCbIPBzCHwDAsqbEHqwQ7O3sGF7J+E5UV1enWvYMnFlBPbhCJUBt+Cq34JCAXjDqkIdiPUXiAFQQx0csHZz4qzH1BeJzKwf/ZMQpmWVZOGZPIYtTDpbpqqbuWezPgTSTTIg78Vg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.25-rc4
Date: Sun, 16 Mar 2008 19:36:26 +0100
User-Agent: KMail/1.9.9
Cc: Anders Eriksson <aeriksson@fastmail.fm>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803161907.04581.bzolnier@gmail.com> <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803161111000.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803161936.26419.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008, Linus Torvalds wrote:

> > Moreover the problem was initially narrowed down to commit
> > 852738f39258deafb3d89c187cb1a4050820d555 which is two commits _before_
> > the one that we are currently discussing.
> 
> .. and that initial narrowing down is now in doubt, with the new one 
> pointing to that DRQ-logic-changing commit!
> 
> IOW, Anders re-did things more carefully, and came to a new result. Why 
> are you apparenrly ignoring that fact?

I just lost track at what is confirmed and what not...

Anders, does the kernel at commit 852738f39258deafb3d89c187cb1a4050820d555
also fail or not?

Thanks,
Bart
