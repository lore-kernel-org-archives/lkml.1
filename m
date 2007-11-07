Return-Path: <linux-kernel-owner+w=401wt.eu-S1759112AbXKGRdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112AbXKGRdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 12:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbXKGRdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 12:33:41 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753122AbXKGRdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:33:40 -0500
Date: Wed, 7 Nov 2007 09:33:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: eranian@hpl.hp.com, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-Id: <20071107093313.b10e60c8.akpm@linux-foundation.org>
In-Reply-To: <20071107170820.GB8358@kroah.com>
References: <20071107003454.GA13374@kroah.com>
	<20071107134255.GE14646@frankl.hpl.hp.com>
	<20071107170820.GB8358@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 7 Nov 2007 09:08:20 -0800 Greg KH <greg@kroah.com> wrote:
> On Wed, Nov 07, 2007 at 05:42:55AM -0800, Stephane Eranian wrote:
> > Greg,
> > 
> > Perfmon sysfs document has been updated following your adivce.
> > you can check out in my perfmon tree  the following commit:
> > 
> > 	e83278f879e52ecee025effe9ad509fd51e4a516
> 
> Where is this git tree located?  On git.kernel.org somewhere?
> 


I get mine from git+ssh://master.kernel.org/pub/scm/linux/kernel/git/eranian/linux-2.6.git
