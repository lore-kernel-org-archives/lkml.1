Return-Path: <linux-kernel-owner+w=401wt.eu-S1756447AbZC0J7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbZC0J7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:59:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbZC0J7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:59:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56728 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752153AbZC0J7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:59:38 -0400
Date: Fri, 27 Mar 2009 09:58:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327095852.09c41a43@lxorguk.ukuu.org.uk>
In-Reply-To: <20090326171148.9bf8f1ec.akpm@linux-foundation.org>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<49C88C80.5010803@krogh.cc>
	<72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
	<20090325183011.GN32307@mit.edu>
	<alpine.LFD.2.00.0903251139260.3032@localhost.localdomain>
	<20090325220530.GR32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> userspace can do it quite easily.  Run a self-tuning script after
> installation and when the disk hardware changes significantly.

Which is "all the time" in some configurations. It really needs to be
self tuning internally based on the observed achieved rates (just as you
don't use a script to tune your network bandwidth each day)
