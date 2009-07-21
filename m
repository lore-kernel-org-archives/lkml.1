Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbZGUGBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbZGUGBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 02:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZGUGBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 02:01:18 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56180 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbZGUGBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 02:01:17 -0400
Date: Tue, 21 Jul 2009 11:31:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] taskstats-fork: Add a new taskstats command to get
	notification on fork/clone
Message-ID: <20090721060114.GS24157@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <200907211031.48294.knikanth@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <200907211031.48294.knikanth@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nikanth Karthikesan <knikanth@suse.de> [2009-07-21 10:31:48]:

> Add a new taskstats command to register for notification, whenever a new task
> forks in the cpumask specified.
>

The changelog is sucky.. why do we need this? Why is proc-events not
sufficient?
 

-- 
	Balbir
