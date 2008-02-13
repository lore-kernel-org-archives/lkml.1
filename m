Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbYBMH1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbYBMH1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765891AbYBMH13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:27:29 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60449 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbYBMH12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:27:28 -0500
Date: Wed, 13 Feb 2008 16:27:34 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Greg KH <gregkh@suse.de>
Subject: Re: split up feature-removal-schedule.txt
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20080213070215.GA11969@kroah.com>
References: <20080213070215.GA11969@kroah.com>
Message-Id: <20080213162634.D897.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

> In the big "linux-next" series of emails, David Miller suggested that
> the feature-removal-schedule file be broken up into little pieces, as it
> is causing merge problems for different trees.
> 
> This changeset does just that.  Turns out that this makes things more
> readable, as it's easier to look at a list of filenames for things than
> picking through a 300 line text file.

Excellent!
thank you for good job.


- kosaki


