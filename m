Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbYHCDkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbYHCDkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYHCDkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:40:06 -0400
Received: from relay04.mail-hub.dodo.com.au ([123.2.6.239]:61282 "EHLO
	relay04.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbYHCDkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:40:05 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Grant Coady <gcoady.lk@gmail.com>, achim_leubner@adaptec.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] GDT SCSI DISK ARRAY: fix split line comments for grep
Date: Sun, 03 Aug 2008 13:39:45 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <4v9a94lbmt1ript986mkbtgr1g6jffamnc@4ax.com>
References: <rgo9945k1lva0nh1rfrtaahoingstahl7o@4ax.com> <1217732421.30264.5.camel@localhost.localdomain>
In-Reply-To: <1217732421.30264.5.camel@localhost.localdomain>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Aug 2008 22:00:21 -0500, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

>On Sun, 2008-08-03 at 08:44 +1000, Grant Coady wrote:
>> Hi there,
>> 
>> Following patch unsplits some comment lines that hold driver device 
>> names so they can be grepped.
>
>I don't actually see a problem to be fixed here.  The original author
>obviously split the lines to be under 80 chars.  The actual board names
>are still integral in the comments and thus greppable even for the split
>lines.  What is it that you think needs to be fixed?

I suppose if you always grep with context there's no problem?

It's the only file I found with this issue while doing other stuff.

Grant.
