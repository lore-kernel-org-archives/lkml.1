Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbZLHMZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbZLHMZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 07:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZLHMZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 07:25:30 -0500
Received: from smtp.nokia.com ([192.100.122.233]:62544 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZLHMZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 07:25:30 -0500
Subject: Re: [PATCH] UBIFS: PTR_ERR return of wrong pointer in check_leaf()
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1D0169.3040507@gmail.com>
References: <4B1D0169.3040507@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 14:25:15 +0200
Message-Id: <1260275115.19669.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Dec 2009 12:25:20.0464 (UTC) FILETIME=[81FD4500:01CA7801]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 14:21 +0100, Roel Kluin wrote:
> Return the PTR_ERR of the correct pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  fs/ubifs/debug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pushed to ubifs-2.6.git tree, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

