Return-Path: <linux-kernel-owner+w=401wt.eu-S1752498AbZGOGxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbZGOGxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZGOGxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:53:36 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59854 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZGOGxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:53:35 -0400
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: linux-mtd@lists.infradead.org, Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>
References: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jul 2009 09:52:30 +0300
Message-Id: <1247640750.11353.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 15 Jul 2009 06:52:34.0773 (UTC) FILETIME=[D5331850:01CA0518]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 07:49 +0530, Subrata Modak wrote:
> Following fix is inspired by David Howells fix few days back:
> http://lkml.org/lkml/2009/7/9/109,
> 
> Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
> ---

Removed junk comma at the end of "signed-off-by" and pushed to
the ubifs-2.6.git tree:

http://git.infradead.org/ubifs-2.6.git?a=commit;h=5c1507e6097c4abc13bbad69de137366c9043f22

Thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

