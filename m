Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbXIRJqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbXIRJqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 05:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbXIRJpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 05:45:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:8978 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbXIRJpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 05:45:52 -0400
Message-ID: <46EF9EF6.7090805@mellanox.co.il>
Date: Tue, 18 Sep 2007 11:48:38 +0200
Reply-To: tziporet@dev.mellanox.co.il
Organization: Mellanox Technologies
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: Hal Rosenstock <hrosenstock@xsigo.com>
CC: Sean Hefty <sean.hefty@intel.com>, netdev@vger.kernel.org,
       "'Roland Dreier'" <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
References: <adahclymos8.fsf@cisco.com>	<000401c7f632$c993e8e0$65cc180a@amr.corp.intel.com> <1190034015.6272.83.camel@hrosenstock-ws.xsigo.com>
In-Reply-To: <1190034015.6272.83.camel@hrosenstock-ws.xsigo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Tziporet Koren <tziporet@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hal Rosenstock wrote:
>
> Has anyone tested these with QoS actually be used ? I suppose this
> requires Connect-X.
>   

You can test it with a switch without ConnectX.
If you want that the HCA will react to the QoS setting too then you 
should have ConnectX



Tziporet
