Return-Path: <linux-kernel-owner+w=401wt.eu-S1763610AbXIMSWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763610AbXIMSWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbXIMSWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:22:23 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49098 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbXIMSWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:22:22 -0400
In-Reply-To: <adahclymos8.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org
MIME-Version: 1.0
Subject: Re: InfiniBand/RDMA merge plans for 2.6.24
X-Mailer: Lotus Notes Release 7.0 HF144 February 01, 2006
Message-ID: <OF79F6C618.02039854-ON87257355.00646A35-88257355.0064AB34@us.ibm.com>
From: Shirley Ma <xma@us.ibm.com>
Date: Thu, 13 Sep 2007 11:22:16 -0700
X-MIMETrack: Serialize by Router on D03MC012/03/M/IBM(Release 7.0.2FP2HF51 | June 19, 2007) at
 09/13/2007 12:22:20,
	Serialize complete at 09/13/2007 12:22:20
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland,
 
        Since ehca can support 4K MTU, we would like to see a patch in 
IPoIB to allow link MTU to be up to 4K instead of current 2K for 2.6.24 
kernel. The idea is IPoIB link MTU will pick up a return value from SM's 
default broadcast MTU. This patch should be a small patch, I hope you are 
OK with this.

Thanks
Shirley
