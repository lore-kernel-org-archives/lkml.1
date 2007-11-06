Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbXKFLjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbXKFLjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 06:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXKFLjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 06:39:08 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:3395 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbXKFLjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 06:39:07 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Jan Kara <jack@suse.cz>
Subject: Re: Future of Linux 2.6.22.y series
Date: Tue, 6 Nov 2007 12:38:50 +0100
User-Agent: KMail/1.9.7
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <20071105181332.GB28628@kroah.com> <20071106112615.GG32704@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20071106112615.GG32704@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711061238.50162.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 6. November 2007 schrieb Jan Kara:
>   In that case you might be interested in picking up the attached fix :)
> I don't know if you already didn't get it...

---
[PATCH] rd: fix data corruption on memory pressure
---

The patch is currently in mm but not yet upstream. As soon as it is merged,
this patch is a good candidate for stable.

Christian
