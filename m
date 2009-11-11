Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZKKH5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZKKH5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755719AbZKKH5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:57:53 -0500
Received: from smtp.nokia.com ([192.100.105.134]:54754 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZKKH5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:57:52 -0500
Subject: Re: [PATCH] UBI: Ensure index is positive
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AF0893E.8040101@gmail.com>
References: <4AF0893E.8040101@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 09:57:37 +0200
Message-Id: <1257926257.21596.874.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Nov 2009 07:57:38.0814 (UTC) FILETIME=[A358B9E0:01CA62A4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 20:49 +0100, Roel Kluin wrote:
> The index is signed, make sure it is not negative
> when we read the array element.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

This is not UBI, this is mtd. I've amended the subject and pushed this
patch to my l2-mtd-2.6, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

