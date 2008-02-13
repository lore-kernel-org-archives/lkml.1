Return-Path: <linux-kernel-owner+w=401wt.eu-S1761710AbYBMHED@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710AbYBMHED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:04:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbYBMHDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:03:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56482
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbYBMHDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:03:52 -0500
Date: Tue, 12 Feb 2008 23:04:23 -0800 (PST)
Message-Id: <20080212.230423.172781444.davem@davemloft.net>
To: gregkh@suse.de
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] split up feature-removal-schedule.txt
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080213070215.GA11969@kroah.com>
References: <20080213070215.GA11969@kroah.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Tue, 12 Feb 2008 23:02:15 -0800

> In the big "linux-next" series of emails, David Miller suggested that
> the feature-removal-schedule file be broken up into little pieces, as it
> is causing merge problems for different trees.
> 
> This changeset does just that.  Turns out that this makes things more
> readable, as it's easier to look at a list of filenames for things than
> picking through a 300 line text file.
> 
> Please pull from:
> 	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Acked-by: David S. Miller <davem@davemloft.net>

Thanks for doing this work.
