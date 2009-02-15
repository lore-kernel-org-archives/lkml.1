Return-Path: <linux-kernel-owner+w=401wt.eu-S1756086AbZBOVay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086AbZBOVay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbZBOVak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:30:40 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:14579 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbZBOVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:30:38 -0500
Message-ID: <4998897A.3030904@chelsio.com>
Date: Sun, 15 Feb 2009 13:30:34 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/43] drivers/net/cxgb3: fix sparse warning: symbol shadows
 an earlier one
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net> <20090214211557.23489.75670.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214211557.23489.75670.stgit@vmbox.hanneseder.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2009 21:31:15.0531 (UTC) FILETIME=[BB41D9B0:01C98FB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Impact: Move variable declaration as close to usage as possible.
>
> Fix this sparse warning:
>   drivers/net/cxgb3/cxgb3_main.c:1586:21: warning: symbol 'cap' shadows an earlier one
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>   
Acked-by: Divy Le Ray <divy@chelsio.com>
