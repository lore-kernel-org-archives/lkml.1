Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZBOVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZBOVc0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:32:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZBOVcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:32:14 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:14597 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZBOVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:32:13 -0500
Message-ID: <499889D7.2070305@chelsio.com>
Date: Sun, 15 Feb 2009 13:32:07 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/43] drivers/net/cxgb3: fix sparse warnings: fix signedness
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net> <20090214211612.23489.60993.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214211612.23489.60993.stgit@vmbox.hanneseder.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2009 21:32:48.0906 (UTC) FILETIME=[F2E9BEA0:01C98FB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Fix this sparse warning:
>   drivers/net/cxgb3/ael1002.c:1010:60: warning: incorrect type in argument 4 (different signedness)
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>   
Acked-by: Divy Le Ray <divy@chelsio.com>
