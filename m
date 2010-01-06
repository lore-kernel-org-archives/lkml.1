Return-Path: <linux-kernel-owner+w=401wt.eu-S932614Ab0AFSmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab0AFSmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483Ab0AFSmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:42:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:46325 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932390Ab0AFSmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:42:20 -0500
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc3
From: James Bottomley <James.Bottomley@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1001060907560.3630@localhost.localdomain>
References: <1262797332.2946.147.camel@mulgrave.site>
	 <alpine.LFD.2.00.1001060907560.3630@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 13:42:13 -0500
Message-Id: <1262803333.2946.249.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 09:08 -0800, Linus Torvalds wrote:
> 
> On Wed, 6 Jan 2010, James Bottomley wrote:
> > 
> > The patch is available at:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> No it's not. That has a commit from Dec 10th as the top commit.
> 
> Forgot to push?

No, sorry, asleep at the wheel, that's my merge window repo.  The
correct URL for the bug fixes repo is

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

James


