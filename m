Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZJFHMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZJFHMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbZJFHMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:12:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:33203 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752432AbZJFHMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:12:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/pIVoS91rpoUyQ7nyn8kwEPET1/4ccuyIkQ+DMBH
	xfZfDCciKAPH7g
Subject: Re: complete IO hang since a few kernel revision
From: Mike Galbraith <efault@gmx.de>
To: Norbert Preining <preining@logic.at>
Cc: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091005083308.GB5612@gandalf.dynalias.org>
References: <20091005011626.GH4335@gamma.logic.tuwien.ac.at>
	 <4AC9607D.6050900@datenparkplatz.de>
	 <20091005083308.GB5612@gandalf.dynalias.org>
Content-Type: text/plain
Date: Tue, 06 Oct 2009 09:11:51 +0200
Message-Id: <1254813111.6293.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-10-05 at 17:33 +0900, Norbert Preining wrote:
> On Mon, 05 Oct 2009, Ulrich Lukas wrote:
> > A number of patches went into 2.6.32-rc3 which was released today.
> 
> Ok, with 2.6.32-rc3 running now.
> 
> > Can you test if your problems are solved with this latest version?
> 
> Example:
> dpkg-source -x of a big debian source package
> which is more or less untarring a big .tar and then applying a diff
> which is much smaller (tar.gz: 482M, diff.gz: 412k)
> 
> The dpkg-source has finished, I am back at the prompt.
> 
> At the same time a simple
> 	$ <ENTER>
> in a different xterm did not produce *any* thing, no output, for about
> 30 seconds. I mean 30 seconds waiting for an empty command is a bit
> strange I would say.
> 
> I don't know to which this is related, but it seems quite buggy.

I've tried unsuccessfully to reproduce this behavior.

Since it doesn't appear to be something readily reproducible, more
information and/or some digging on your part may be needed.

