Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbXKGRrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbXKGRrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbXKGRqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:46:53 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35459 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893AbXKGRqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:46:52 -0500
Date: Wed, 7 Nov 2007 09:41:50 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: eranian@hpl.hp.com, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071107174150.GA9692@kroah.com>
References: <20071107003454.GA13374@kroah.com> <20071107134255.GE14646@frankl.hpl.hp.com> <20071107170820.GB8358@kroah.com> <20071107093313.b10e60c8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107093313.b10e60c8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 09:33:13AM -0800, Andrew Morton wrote:
> > On Wed, 7 Nov 2007 09:08:20 -0800 Greg KH <greg@kroah.com> wrote:
> > On Wed, Nov 07, 2007 at 05:42:55AM -0800, Stephane Eranian wrote:
> > > Greg,
> > > 
> > > Perfmon sysfs document has been updated following your adivce.
> > > you can check out in my perfmon tree  the following commit:
> > > 
> > > 	e83278f879e52ecee025effe9ad509fd51e4a516
> > 
> > Where is this git tree located?  On git.kernel.org somewhere?
> > 
> 
> 
> I get mine from git+ssh://master.kernel.org/pub/scm/linux/kernel/git/eranian/linux-2.6.git

Thanks, that worked, let me go read the new documentation...
