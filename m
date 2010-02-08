Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab0BHPMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:12:54 -0500
Received: from smtp.nokia.com ([192.100.122.230]:53342 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0BHPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:12:53 -0500
Subject: Re: [PATCH] mtd: Change positive error return into negative in
 mtd_do_writeoob()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B62ABC8.7080607@gmail.com>
References: <4B62ABC8.7080607@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 17:11:35 +0200
Message-ID: <1265641895.2006.75.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Feb 2010 15:12:02.0879 (UTC) FILETIME=[11812CF0:01CAA8D1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 10:35 +0100, Roel Kluin wrote:
> The error return should be negative
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/mtd/mtdchar.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Pushed to l2-mtd-2.6.git/master

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

