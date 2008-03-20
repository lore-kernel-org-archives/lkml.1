Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbYCTCVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbYCTCVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 22:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYCTCVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 22:21:18 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27011 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYCTCVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 22:21:17 -0400
X-IronPort-AV: E=Sophos;i="4.25,527,1199682000"; 
   d="scan'208";a="64690023"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: linux-kernel@vger.kernel.org
Subject: SysRq & serial console...
Date: Wed, 19 Mar 2008 22:21:14 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803192221.15014.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 20 Mar 2008 02:21:11.0931 (UTC) FILETIME=[10C314B0:01C88A31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone validate that SysRq - "q" works properly on serial console with 
CONFIG_GENERIC_TIME not set?

I'm getting a "scheduling while atomic" in getnstimeofday and before I dig too 
deep, wanted to understand if it was a common issue or not...

Thanks
-Robin
