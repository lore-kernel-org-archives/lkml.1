Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZERVWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZERVWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 17:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbZERVVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 17:21:53 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2051 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbZERVVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 17:21:52 -0400
Subject: Re: [PATCH 0/6] drivers/ide Convert printk(KERN_<foo> to pr_<foo>(
From: Joe Perches <joe@perches.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
In-Reply-To: <1242681328.6347.38.camel@localhost.localdomain>
References: <cover.1242609803.git.joe@perches.com>
	 <200905181612.43632.bzolnier@gmail.com>
	 <1242661288.1572.82.camel@Joe-Laptop.home>
	 <1242662198.6347.14.camel@mulgrave.int.hansenpartnership.com>
	 <1242680389.1572.127.camel@Joe-Laptop.home>
	 <1242681328.6347.38.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 18 May 2009 14:21:48 -0700
Message-Id: <1242681709.1572.135.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 21:15 +0000, James Bottomley wrote:
> it's not good for the stability of the code base and
> it can cause problems with subsidiary committers by generating
> unnecessary patch rejections due to code churn.

Bart can decide, coordinate and mitigate.
He's the one that asked for it.
http://lkml.org/lkml/2009/5/17/127

cheers, Joe

