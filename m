Return-Path: <linux-kernel-owner+w=401wt.eu-S1766001AbXGVM3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766001AbXGVM3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760011AbXGVM2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:28:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60662 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947AbXGVM2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:28:54 -0400
Date: Sun, 22 Jul 2007 14:28:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jacob A <jacoba51-tmp@yahoo.com>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.4 Q: list of open files per inode?
In-Reply-To: <35493.81201.qm@web57701.mail.re3.yahoo.com>
Message-ID: <Pine.LNX.4.64.0707221428020.15705@fbirervta.pbzchgretzou.qr>
References: <35493.81201.qm@web57701.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 22 2007 05:26, Jacob A wrote:

>I want to keep an internal state per each registration instance, and I opted
>to use open() as the registration mechanism.

So why not just store it in filp->private_data?



    Jan
-- 



>

	Jan
-- 
