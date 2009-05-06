Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZEFIh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZEFIh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZEFIht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:37:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:48127 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752346AbZEFIht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:37:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19wpjcTNvhwtv4koh0R2J3dOc7LSHmcbwUAZLo3Hf
	tioag3h5MFx9cj
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
From: Mike Galbraith <efault@gmx.de>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@ZenIV.linux.org.uk,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, tigran@aivazian.fsnet.co.uk
In-Reply-To: <957194.27869.qm@web32605.mail.mud.yahoo.com>
References: <409142.83316.qm@web32605.mail.mud.yahoo.com>
	 <20090428182837.62c51f26.akpm@linux-foundation.org>
	 <1240977096.5478.3.camel@marge.simson.net>
	 <20090429011755.c141c599.akpm@linux-foundation.org>
	 <20090429120827.GI8633@ZenIV.linux.org.uk>
	 <1241014725.15095.19.camel@marge.simson.net>
	 <20090505154911.e0309a4f.akpm@linux-foundation.org>
	 <1241585140.5196.28.camel@marge.simson.net>
	 <957194.27869.qm@web32605.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Wed, 06 May 2009 10:37:45 +0200
Message-Id: <1241599065.18090.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 00:55 -0700, Martin Knoblauch wrote:

>  just to bring this back to my problem :-)

Good idea :-)

>  Last week I reported that the "new" sysfs entry in /proc/mounts already comes out of initrd. Does this ring a bell?
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/03048.html

Nope, no bells.

The only thing I can suggest is that you try a bisection.

	-Mike

