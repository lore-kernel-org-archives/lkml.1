Return-Path: <linux-kernel-owner+w=401wt.eu-S1760600AbXGAUd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760600AbXGAUd2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbXGAUdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:33:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:64878 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381AbXGAUdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:33:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,483,1175497200"; 
   d="scan'208";a="263288292"
Message-ID: <46880F86.1070405@intel.com>
Date: Sun, 01 Jul 2007 13:33:10 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070623)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       saw@saw.sw.com.sg
Subject: Re: [2.6 patch] the overdue eepro100 removal
References: <20070701202139.GM10869@stusta.de>
In-Reply-To: <20070701202139.GM10869@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the overdue removal of the eepro100 driver.


...

this needs to be resceduled for 2.6.24 (at least). We're hoping to merge the 
proposed changes (still being worked on) in .23. Milton Miller and David Acker 
are working on that.

Auke
