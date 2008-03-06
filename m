Return-Path: <linux-kernel-owner+w=401wt.eu-S1765102AbYCFAmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765102AbYCFAmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 19:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932373AbYCFAfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 19:35:16 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37167 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbYCFAfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 19:35:12 -0500
Date: Wed, 5 Mar 2008 17:35:09 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.25-rc4
Message-ID: <20080306003509.GU24386@parisc-linux.org>
References: <1204755977.3047.103.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204755977.3047.103.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 04:26:17PM -0600, James Bottomley wrote:
> Apart from the usual crop of bug fixes, it is hoped that both gdth
> (under all circumstances) and aic94xx (under protocol errors) now work
> after this.
> 
> The patch is available from:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:

James, you've overlooked
http://marc.info/?l=linux-scsi&m=119161490104667&w=2 again.  I last sent
it to you on Feb 25th

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
