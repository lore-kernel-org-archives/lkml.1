Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbXKYSeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbXKYSeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 13:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbXKYSd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 13:33:56 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:40017 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbXKYSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 13:33:55 -0500
Date: Sun, 25 Nov 2007 12:33:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH 1/2] msi: set 'En' bit of MSI Mapping Capability on HT
 platform
In-reply-to: <fa.o8FrHkCTygSL3HgQ8yHeTr2D3tI@ifi.uio.no>
To: peerchen <peerchen@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, pchen <pchen@nvidia.com>,
       acurrid <acurrid@nvidia.com>
Message-id: <4749C00A.8050802@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.o8FrHkCTygSL3HgQ8yHeTr2D3tI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

peerchen wrote:
> According to the HyperTransport spec, 'En' indicate if the MSI Mapping is active. So it should be set when enable the MSI.
> 
> The patch base on kernel 2.6.24-rc3
> 
> Signed-off-by: Andy Currid <acurrid@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>

Isn't there a way we can make this work for any upstream HT bridge, 
rather than only for specific NVIDIA chipsets?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

