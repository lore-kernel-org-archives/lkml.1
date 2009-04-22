Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbZDVMkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbZDVMkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 08:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbZDVMkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 08:40:11 -0400
Received: from mailhost-q1-m2.internext.fr ([78.40.49.193]:59898 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752327AbZDVMkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 08:40:10 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Apr 2009 08:40:10 EDT
Date: Wed, 22 Apr 2009 14:31:09 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] block bits for 2.6.30-rc3
Message-ID: <20090422123109.GA22631@localhost.localdomain>
References: <20090422120355.GD4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422120355.GD4593@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> A collection of fixes for 2.6.30-rc3. It includes fixes for
> regressions and bug fixes in general, along with two buglets in CFQ.
> Please pull.

What about this bug in CFQ: http://lkml.org/lkml/2009/4/20/68 ?

Do you plan to have it fixed for 2.6.30 or will it wait until 2.6.31?


Thanks,

-- 
Damien
