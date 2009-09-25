Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbZIYHVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbZIYHVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 03:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbZIYHVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 03:21:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48342 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbZIYHVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 03:21:06 -0400
Subject: Re: Linux 2.6.31.1
From: Peter Volkov <pva@gentoo.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20090924174002.GE17077@kroah.com>
References: <20090924174002.GE17077@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Sep 2009 11:18:41 +0400
Message-Id: <1253863121.22793.24.camel@tablet>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Чтв, 24/09/2009 в 10:40 -0700, Greg KH пишет:
> I'm announcing the release of the 2.6.31.1 kernel.  All users of the
> 2.6.31 kernel series are very strongly encouraged to upgrade.

Looks like the following patch was missed:
http://patchwork.kernel.org/patch/48380/

and link to the thread where it was discussed:
http://lkml.org/lkml/2009/9/17/397

Please, add it to 2.6.31. Thanks.

-- 
Peter.

