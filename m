Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbXLGCvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbXLGCvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 21:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXLGCvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 21:51:12 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:31093 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbXLGCvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:51:10 -0500
Message-ID: <4758B4FC.4010307@chelsio.com>
Date: Thu, 06 Dec 2007 18:50:36 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>,
       Wen Xiong <wenxiong@us.ibm.com>
Subject: Re: [PATCH 0/2] cxgb3 - driver update
References: <4756EA9D.1070204@chelsio.com>
In-Reply-To: <4756EA9D.1070204@chelsio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Dec 2007 02:49:17.0671 (UTC) FILETIME=[C2949770:01C8387B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> Jeff,
>
> I'm submitting a patch series for inclusion in 2.6.25.
> The patches are built against netdev#upstream.
>
> Here is a brief description:
> - Update GPIO pinning and MAC support for T3C adapters
> - Enable parity error detection.
Jeff,

I posted a third patch to fix the EEH code and add a missing
softirq blocking call.

Cheers,
Divy
