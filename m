Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbYETFgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbYETFgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 01:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYETFgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 01:36:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58322 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411AbYETFgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 01:36:13 -0400
Date: Mon, 19 May 2008 22:35:49 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>, manfred@colorfullife.com,
       paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, efault@gmx.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH 7/9] Make idr_remove rcu-safe
Message-ID: <20080520053549.GA12820@tpepper-t42p.dolavim.us>
References: <20080507113553.395937000@bull.net> <20080507113737.562143000@bull.net> <20080514195925.GA8994@tpepper-t42p.dolavim.us> <482BE8DD.2020101@bull.net> <20080520052904.GA11326@tpepper-t42p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520052904.GA11326@tpepper-t42p.dolavim.us>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19 May at 22:29:05 -0700 lnxninja@linux.vnet.ibm.com said:
> 
> (detail plots from this same run attached...)
> 

Errr...clumsy fingers.  I attached a plot that had up to 128 threads, which
is really just noise over 60-ish.

At any rate, if anybody would like to see more runs/details let me know.

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center
