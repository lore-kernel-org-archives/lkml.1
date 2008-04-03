Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbYDCNWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbYDCNWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYDCNWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:22:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:65231 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbYDCNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:22:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=qvovKLrHStiXo9UaRCf9sipubfYrOS03teoW+6Wk6ew4YQIzJny2o7EdhCP1w/qO1CYsmC5Y9S8oTO91gMtt8hXV6mQPuQ+r9cPCjfYPU8Si/F3f/Afsf8A3pu/UdLA05fbAHPXA8MOXJFYOcxGB5oKlBic0fzYgNYvGSHdQxFc=
Date: Thu, 3 Apr 2008 17:21:42 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com
Subject: [PATCH 0/6] Clocklib: generic clocks framework
Message-ID: <20080403132142.GA26882@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an updated version of the clocklib patchset.

Changes since last repost:

* fix an clks_register error path, as noted by Pavel Machek

-- 
With best wishes
Dmitry

