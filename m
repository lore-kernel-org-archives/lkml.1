Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbYL3Tmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbYL3Tmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 14:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYL3TmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 14:42:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58004 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbYL3TmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 14:42:22 -0500
Date: Tue, 30 Dec 2008 11:41:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: jens.axboe@oracle.com, kmannth@us.ibm.com, linux-kernel@vger.kernel.org,
       sekharan@us.ibm.com, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Patch][RFC] Supress Buffer I/O errors when SCSI REQ_QUIET flag
 set
Message-Id: <20081230114138.cd9e9763.akpm@linux-foundation.org>
In-Reply-To: <20081230113514.fe09d495.akpm@linux-foundation.org>
References: <1227561983.6487.32.camel@keith-laptop>
	<20081125091917.GU26308@kernel.dk>
	<20081230113514.fe09d495.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 11:35:14 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> During the merge
> window, giving a nice pile of rejects to keep me amused.

Seems that the rejects are due to other churn.  Where the heck did
all the slab defrag code disappear to??

I'll need to revert to yesterday's linux-next I think.  Pekka, has
that stuff been dropped?
