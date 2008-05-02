Return-Path: <linux-kernel-owner+w=401wt.eu-S935320AbYEBUQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935320AbYEBUQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763288AbYEBUQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:16:25 -0400
Received: from smtp.opengridcomputing.com ([209.198.142.2]:48006 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755585AbYEBUQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:16:25 -0400
Message-ID: <481B7697.2080500@opengridcomputing.com>
Date: Fri, 02 May 2008 15:16:23 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [PATCH 2.6.26 1/3] RDMA/cxgb3: QP flush fixes
References: <20080502161741.30500.95337.stgit@dell3.ogc.int> <adamyn84mh9.fsf@cisco.com>
In-Reply-To: <adamyn84mh9.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> thanks, applied all 3... (1/3 was against a slightly old tree, so I had
> to fix up __FUNCTION__ -> __func__ in the context of the diffs)
>   
Sorry about that.  Someday I'll learn __func__.

;-)


