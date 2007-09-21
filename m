Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbXIURrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbXIURrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXIURrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:47:43 -0400
Received: from twin.jikos.cz ([213.151.79.26]:59496 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbXIURrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:47:42 -0400
Date: Fri, 21 Sep 2007 19:47:38 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Miloslav Semler <majkls@prepere.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: sysfs_readdir patch for 2.6.16.53
In-Reply-To: <46F3FFE9.7050503@prepere.com>
Message-ID: <Pine.LNX.4.64.0709211946190.22331@twin.jikos.cz>
References: <46F3FFE9.7050503@prepere.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Miloslav Semler wrote:

> so there is some backport of sysfs_readdir patch from 2.6.22.6 to 
> 2.6.16.53. It is not well tested but it is actually working on my 
> kernel.

Hi Miloslav,

the patch is whitespace damaged, it is in not acceptable format (diff -u, 
please read Documentation/SubmittingPatches), it is missing proper 
changelog (why would we need this backported for 2.6.16.53) and a proper 
Signed-off-by: line.

Thanks,

-- 
Jiri Kosina
