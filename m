Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZFSHBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZFSHBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbZFSHA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:00:59 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:36152 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZFSHA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:00:58 -0400
Date: Fri, 19 Jun 2009 09:00:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: import of i2c series failed
Message-ID: <20090619090045.59899d69@hyperion.delvare>
In-Reply-To: <20090619101020.9b1f5054.sfr@canb.auug.org.au>
References: <20090619101020.9b1f5054.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, 19 Jun 2009 10:10:20 +1000, Stephen Rothwell wrote:
> Hi Jean,
> 
> I got this error import the i2c quilt series:
> 
> i2c-core-07-limit-locking.patch
> error: patch failed: drivers/i2c/i2c-core.c:418
> error: drivers/i2c/i2c-core.c: patch does not apply
> 
> I noticed that the BASE changed from 3.6.30-git11 yesterday to just
> 2.6.30 today, so I tried again against 2.6.30-git11 and it all applied.

User error, sorry about that. I erroneously updated the series file
while the latest git patch was temporarily not applied to my local
tree. It's all fixed now, sorry for the trouble.

-- 
Jean Delvare
