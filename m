Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbYBFTtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbYBFTtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759568AbYBFTt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:49:27 -0500
Received: from wx-out-0506.google.com ([66.249.82.224]:58490 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbYBFTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:49:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wSBs9ILTblIR7xDTwRukp8l54M6QgeQZdcg36SltCND/52Lo6DnAsjXEAB6iJb3ryZ19Icsnnu59wragwDW8BnAccnTaIwPc2u1mNCTBrf1dH+yqjjgVmxwLelXJ1WEyGW2u9dZ/j1NGxtltvkt9dLvA9DGLDlFOy3OOzeqwkFw=
Subject: Re: feature-removal-schedule.txt is getting out of date again
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <200802062054.59755.bzolnier@gmail.com>
References: <alpine.LFD.1.00.0802060419140.17178@localhost.localdomain>
	 <200802062054.59755.bzolnier@gmail.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 11:49:20 -0800
Message-Id: <1202327360.5820.24.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-06 at 20:54 +0100, Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> On Wednesday 06 February 2008, Robert P. J. Day wrote:
> > 
> >   yes, i realize i'm sounding like a broken record but, once again,
> > Documentation/feature-removal-schedule.txt is slipping out of date WRT
> > items that are now slightly, if not noticeably, behind schedule for
> > removal.
> 

I had pinged people about a week ago on lots of these items, for the
most part patches are staged and going in through various trees, let's
wait for rc1 and see what has landed by then.

Harvey

