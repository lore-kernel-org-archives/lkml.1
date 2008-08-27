Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYH0FdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYH0FdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 01:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYH0FdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 01:33:12 -0400
Received: from smtp.nokia.com ([192.100.122.233]:55100 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYH0FdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 01:33:10 -0400
Subject: Re: [PATCH 1/2] Clean up of code found when adding support for >
	2GiB MTD devices
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Bruce Leonard <brucle@earthlink.net>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <48AB3AAC.7030900@earthlink.net>
References: <48AB3AAC.7030900@earthlink.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 27 Aug 2008 08:29:40 +0300
Message-Id: <1219814980.18027.123.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 27 Aug 2008 05:32:47.0991 (UTC) FILETIME=[570AA070:01C90806]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2008-08-19 at 14:27 -0700, Bruce Leonard wrote:
> These are just some code cleanups that I found while working on the MTD sub-system.
> From: brucle <brucle@selinc.com>
> Date: Wed, 13 Aug 2008 17:16:48 -0700
> Subject: [PATCH] Code clean up preping for support of > 2GiB MTD devices
> 
> Signed-off-by: Bruce D. Leonard <brucle@selinc.com>

For this clean-up patch,

Acked-by: Artem Bityutskiy <dedekind@infradead.org>

However, are you shure it is against the mtd-2.6.git tree?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

