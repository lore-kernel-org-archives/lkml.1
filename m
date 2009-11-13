Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbZKMHqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbZKMHqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 02:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbZKMHqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 02:46:33 -0500
Received: from [95.166.99.235] ([95.166.99.235]:52326 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbZKMHqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 02:46:32 -0500
Date: Fri, 13 Nov 2009 08:46:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mikem@beardog.cce.hp.com, achiang@hp.com, brace@beardog.cce.hp.com
Subject: Re: [PATCH 00/11] cciss: driver updates
Message-ID: <20091113074637.GS8742@kernel.dk>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12 2009, Stephen M. Cameron wrote:
> Updates for cciss, main items are: retry driver initiated commands
> on unit attention condition, do not automatically rescan for devices
> on unit attention, support for more scatter gather elements and larger
> transfers.

Thanks Stephen, applied for 2.6.33.

-- 
Jens Axboe

