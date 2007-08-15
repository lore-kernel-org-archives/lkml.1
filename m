Return-Path: <linux-kernel-owner+w=401wt.eu-S1763129AbXHOAKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763129AbXHOAKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbXHOAJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:09:55 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:24970 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbXHOAJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:09:54 -0400
Message-ID: <46C2444E.1080000@chelsio.com>
Date: Tue, 14 Aug 2007 17:09:50 -0700
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH 9/13] cxgb3 - Update internal memory management
References: <20070811063015.8166.66861.stgit@speedy5> <46C14189.8010304@garzik.org>
In-Reply-To: <46C14189.8010304@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2007 00:08:33.0690 (UTC) FILETIME=[6B3A5FA0:01C7DED0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>
> Divy Le Ray wrote:
> > From: Divy Le Ray <divy@chelsio.com>
> >
> > Set PM1 internal memory to round robin mode
> >
> > Signed-off-by: Divy Le Ray <divy@chelsio.com>
>
> why?
>
For multiport adapters, it balances access to this internal memory.

Divy
