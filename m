Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab0BRLbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:31:53 -0500
Received: from stinky.trash.net ([213.144.137.162]:62993 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab0BRLbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:31:51 -0500
Message-ID: <4B7D2522.6070101@trash.net>
Date: Thu, 18 Feb 2010 12:31:46 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Venkata Mohan Reddy <mohanreddykv@gmail.com>,
       Wensong Zhang <wensong@linux-vs.org>, Julian Anastasov <ja@ssi.bg>
Subject: Re: [IPVS] SCTP Trasport Loadbalancing Support
References: <20100218010642.GD16530@verge.net.au>
In-Reply-To: <20100218010642.GD16530@verge.net.au>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Horman wrote:
> From: Venkata Mohan Reddy <mohanreddykv@gmail.com>
> 
> Enhance IPVS to load balance SCTP transport protocol packets. This is done
> based on the SCTP rfc 4960. All possible control chunks have been taken
> care. The state machine used in this code looks some what lengthy. I tried
> to make the state machine easy to understand.

Applied, thanks.
