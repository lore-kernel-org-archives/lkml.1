Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYCDGc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYCDGc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYCDGcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:32:48 -0500
Received: from smtp.nokia.com ([192.100.122.230]:65350 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbYCDGcs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:32:48 -0500
Subject: Re: [2.6 patch] mtd/ubi/vtbl.c: fix memory leak
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080303180752.GK26072@cs181133002.pp.htv.fi>
References: <20080303180752.GK26072@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=utf-8
Date: Tue, 04 Mar 2008 08:27:33 +0200
Message-Id: <1204612053.23706.13.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 Mar 2008 06:32:25.0348 (UTC) FILETIME=[829BFC40:01C87DC1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-03 at 20:07 +0200, Adrian Bunk wrote:
> This patch fixes a memory leak introduced by commit 
> 4ccf8cffa963c7b5bdc6d455ea9417084ee49aa8 and spotted by the Coverity 
> checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Good catch, thank you!

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

