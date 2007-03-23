Return-Path: <linux-kernel-owner+w=401wt.eu-S933961AbXCWHOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933961AbXCWHOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 03:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422656AbXCWHOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 03:14:34 -0400
Received: from smtp.osdl.org ([65.172.181.24]:40428 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934023AbXCWHOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 03:14:33 -0400
Date: Thu, 22 Mar 2007 23:14:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: "LKML, " <linux-kernel@vger.kernel.org>
Subject: Re: + uml-create-archh.patch added to -mm tree
Message-Id: <20070322231431.758380c7.akpm@linux-foundation.org>
In-Reply-To: <200703230751.47355.blaisorblade@yahoo.it>
References: <200703222144.l2MLiXrA031093@shell0.pdx.osdl.net>
	<200703230751.47355.blaisorblade@yahoo.it>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Mar 2007 07:51:47 +0100 Blaisorblade <blaisorblade@yahoo.it> wrote:

> On Thursday 22 March 2007 22:44, akpm@linux-foundation.org wrote:
> > The patch titled
> >      uml: mreate arch.h
> 	   ^
> > has been added to the -mm tree.  Its filename is
> >      uml-create-archh.patch
> mreate? I've also seen this in all other patches of this batch (examples 
> below), and both Jeff's original mails and patch filenames are correct. What 
> are your scripts doing here?

That's a semi-manual attempt to turn the incoming chaos into semi-consistent
output, which went wrong.  Fixed, thanks.
