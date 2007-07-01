Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbXGAJ1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbXGAJ1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 05:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbXGAJ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 05:27:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49246 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbXGAJ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 05:27:32 -0400
Date: Sun, 1 Jul 2007 04:26:19 -0500
From: "Jose R. Santos" <jrs@us.ibm.com>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Message-ID: <20070701042619.2215645f@gara>
In-Reply-To: <1183275490.4010.134.camel@localhost.localdomain>
References: <1183275490.4010.134.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.11; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 03:38:10 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> [PATCH] jbd2 stats through procfs
> 
> The patch below updates the jbd stats patch to 2.6.20/jbd2.
> The initial patch was posted by Alex Tomas in December 2005
> (http://marc.info/?l=linux-ext4&m=113538565128617&w=2).
> It provides statistics via procfs such as transaction lifetime and size.
> 
> [ This probably should be rewritten to use debugfs?   -- Ted]

Was a decision ever made on whether this should remain on procfs or be
move to use debugfs?  I can recall this being discuss but don't recall
a firm decision on it.

-JRS
