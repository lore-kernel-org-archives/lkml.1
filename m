Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbZDJIEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbZDJIEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 04:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759406AbZDJIEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 04:04:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbZDJIEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 04:04:07 -0400
Date: Fri, 10 Apr 2009 10:05:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS interrupts in the
	video code
Message-ID: <20090410080553.GD16512@elf.ucw.cz>
References: <49DE7F79.4030106@zytor.com> <tip-cf06de7b9cdd3efee7a59dced1977b3c21d43732@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-cf06de7b9cdd3efee7a59dced1977b3c21d43732@git.kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-04-09 23:13:47, H. Peter Anvin wrote:
> Commit-ID:  cf06de7b9cdd3efee7a59dced1977b3c21d43732
> Gitweb:     http://git.kernel.org/tip/cf06de7b9cdd3efee7a59dced1977b3c21d43732
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Wed, 1 Apr 2009 18:20:11 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 9 Apr 2009 16:08:12 -0700
> 
> x86, setup: "glove box" BIOS interrupts in the video code
> 
> Impact: BIOS proofing
> 
> "Glove box" off BIOS interrupts in the video code.
> 
> LKML-Reference: <49DE7F79.4030106@zytor.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
