Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbXD0Czb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbXD0Czb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 22:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbXD0Czb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 22:55:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755196AbXD0CzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 22:55:25 -0400
Date: Thu, 26 Apr 2007 19:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm2 breaks 'lvm vgscan'.
Message-Id: <20070426195517.20d7a8b3.akpm@linux-foundation.org>
In-Reply-To: <8526.1177641075@turing-police.cc.vt.edu>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<8526.1177641075@turing-police.cc.vt.edu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 22:31:15 -0400 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 25 Apr 2007 22:57:16 PDT, Andrew Morton said:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc7/2.6.21-rc7-mm2/
> 
> This addition in -rc7-mm1 breaks my laptop (Dell Latitude D820, x86_64 kernel)
> 
> gregkh-driver-sysfs-fix-i_ino-handling-in-sysfs.patch

Thanks for doing the bisection.  It is boring, but helps so much.

> Any ideas?

You cc'ed the right guy ;)
