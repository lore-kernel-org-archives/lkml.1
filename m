Return-Path: <linux-kernel-owner+w=401wt.eu-S2992589AbXDLPmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992589AbXDLPmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 11:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992587AbXDLPmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 11:42:49 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:59836 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992586AbXDLPms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 11:42:48 -0400
Subject: Re: [PATCH 2.6.21] iw_cxgb3 - Add set_tcb_rpl_handler.
From: Steve Wise <swise@opengridcomputing.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Divy Le Ray <divy@chelsio.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Netdev@vger.kernel.org,
       OpenFabrics General <general@lists.openfabrics.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <adaveg1ipki.fsf@cisco.com>
References: <1176382594.9396.1.camel@stevo-desktop>
	 <461E45C3.2050400@chelsio.com>  <adaveg1ipki.fsf@cisco.com>
Content-Type: text/plain
Date: Thu, 12 Apr 2007 10:42:46 -0500
Message-Id: <1176392566.9396.11.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-12 at 08:23 -0700, Roland Dreier wrote:
> So is the cxgb3 net driver change in question already in Linus's tree?
> What is the exact patch that this change goes with?

The patch is the 3rd of 3:

http://marc.info/?l=linux-kernel&m=117617444622279&w=2


Jeff applied it into his upstream tree here:

http://marc.info/?l=linux-netdev&m=117630664627997&w=2




