Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbXLXPNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbXLXPNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbXLXPMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:12:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbXLXPMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:12:52 -0500
Date: Mon, 24 Dec 2007 10:12:46 -0500
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1 - SCSI/blkdev probing hang
Message-ID: <20071224101246.1cd5edcb@bree.surriel.com>
In-Reply-To: <20071220132212.173fa493.akpm@linux-foundation.org>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	<20071220155745.1f079a3b@bree.surriel.com>
	<20071220132212.173fa493.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 13:22:12 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 20 Dec 2007 15:57:45 -0500
> Rik van Riel <riel@redhat.com> wrote:
> 
> > 2.6.24-rc5-mm1 seems to have a hang related to the SCSI or block
> > device probing code.

> It could be a scsi problem, or it could be all the kobject changes in
> Greg's driver tree.  Or a combination of the two.
> 
> Don't know, sorry.

Whatever it was, it's gone now.

2.6.24-rc6-mm1 boots on my system.
