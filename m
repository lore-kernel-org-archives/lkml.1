Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYFCFWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYFCFWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 01:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbYFCFVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 01:21:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYFCFVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 01:21:52 -0400
Date: Mon, 2 Jun 2008 22:20:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Jan Kara <jack@suse.cz>, sct@redhat.com, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
Message-Id: <20080602222044.ff3760fc.akpm@linux-foundation.org>
In-Reply-To: <4844D290.7000802@hitachi.com>
References: <4843CE15.6080506@hitachi.com>
	<4843CFBD.7040706@hitachi.com>
	<20080602124409.GL30613@duck.suse.cz>
	<4844CB39.6060409@hitachi.com>
	<4844D290.7000802@hitachi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 14:11:44 +0900 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:

> Hidehiro Kawai wrote:
> 
> > Subject: [PATCH 4/5] jbd: fix error handling for checkpoint io
> 
> Sorry, I forgot to remove the subject at the first line...

Is OK ;)

Sometimes it helps, when people use WeirdRandomStuff in their patch
titles, or when the patch comes in reply to some email thread which has
an irrelevant Subject:.

