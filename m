Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbYGPI3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbYGPI3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbYGPI3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:29:07 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44573 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbYGPI3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:29:06 -0400
Date: Wed, 16 Jul 2008 10:29:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: jkacur <jkacur@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Make the git URL match usage
In-Reply-To: <200807160919.35833.jkacur@gmail.com>
Message-ID: <alpine.LNX.1.10.0807161028190.26724@fbirervta.pbzchgretzou.qr>
References: <200807160919.35833.jkacur@gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 2008-07-16 09:19, jkacur wrote:

>Change the MAINTAINERS file so that the git URL reads EXACTLY the way someone
>would use it.

>-T:	git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
>+T:	git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git

I would not use it that^ way.

-git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
+git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
