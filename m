Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXHSPRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXHSPRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 11:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbXHSPRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 11:17:24 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:52269 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364AbXHSPRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 11:17:03 -0400
Date: Sun, 19 Aug 2007 19:19:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + proc-export-a-processes-resource-limits-via-proc-pid.patch added to -mm tree
Message-ID: <20070819151950.GA7787@tv-sign.ru>
References: <20070817222228.GA783@tv-sign.ru> <20070818115816.GA23555@hmsreliant.think-freely.org> <20070818125926.GA74@tv-sign.ru> <20070818185529.GA25372@hmsreliant.think-freely.org> <20070818190351.GA98@tv-sign.ru> <20070818232352.GA25994@hmsreliant.think-freely.org> <20070819085707.GB83@tv-sign.ru> <20070819130319.GA25178@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070819130319.GA25178@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Neil Horman wrote:
> Copy That
> 
> Currently, there exists no method for a process to query the resource
> limits of another process.  They can be inferred via some mechanisms but
> they cannot be explicitly determined.  Given that this information can be
> usefull to know during the debugging of an application, I've written this
> patch which exports all of a processes limits via /proc/<pid>/limits.

Looks good, thanks.

Oleg.

