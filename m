Return-Path: <linux-kernel-owner+w=401wt.eu-S934040AbXGLSqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbXGLSqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbXGLSqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:46:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:24014 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbXGLSqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:46:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fyRJU0n5H8P2w7XdtKF6eQZuk+lkJ5OpBpHdR2/NU8u90KO2ue9pRXzQEDKQWpE7YSgEs0xgj216zhiQMnJJJDPNMz2w4/V42gtLy4Ryq08Q5Gwf8zFHqspprnmDbxgfi0zRjlkiALNezf4OchpL6ffF6Hv5b0KHrZ5UCjbMSww=
Message-ID: <78ecab220707121146q577536c2w73c7a4dc6086b17@mail.gmail.com>
Date: Thu, 12 Jul 2007 14:46:38 -0400
From: "Mark Shelby" <mshelby1@gmail.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: kernel autoconfig option?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <11610.1184265341@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <78ecab220707120718q7cfcff43u66f80711c7ec1005@mail.gmail.com>
	 <11610.1184265341@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ha Ha! That's pretty funny!
And having hosed a system or two in my time I can totally relate...

On 7/12/07, Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 12 Jul 2007 10:18:55 EDT, Mark Shelby said:
>
> > Am I just crazy, or wouldn't this idea mke a lot of sense? Wouldn't it
> > pretty much make the kernel "idiot proof" when installing from source?
>
> That's usually not the place where idiots screw up.  It's stuff like
> loading an initrd that doesn't do LVM, and your / is on an LVM partition,
> or going from a kernel that used the IDE drivers to one that uses libata,
> and forgetting to fix /etc/fstab for the /dev/hd -> /dev/sd change, or ...
>
> You get the idea.  At some point, you have to insist that the user's clue
> must be  ----> THIS TALL in order to build their own kernel rather than going
> with what the distro installed.
>
>
