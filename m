Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbXDZODZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbXDZODZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 10:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXDZODZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 10:03:25 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:32963 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800AbXDZODY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 10:03:24 -0400
Date: Thu, 26 Apr 2007 10:03:23 -0400
To: Jordan Crouse <jordan.crouse@amd.com>
Cc: Jean Delvare <khali@linux-fr.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070426140323.GE5577@csclub.uwaterloo.ca>
References: <20070418174256.GB5577@csclub.uwaterloo.ca> <20070419085413.1520feef@hyperion.delvare> <20070419205942.GC5577@csclub.uwaterloo.ca> <20070420194933.0813a359@hyperion.delvare> <20070422154151.GJ5575@csclub.uwaterloo.ca> <20070423114254.71787844@hyperion.delvare> <20070423144710.GD1372@cosmic.amd.com> <20070426145634.3ac2b7a3@hyperion.delvare> <20070426132905.GP5575@csclub.uwaterloo.ca> <20070426133920.GA25456@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426133920.GA25456@cosmic.amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 07:39:20AM -0600, Jordan Crouse wrote:
> There is no ISA on the LX.

Isn't LPC a good equivalant?

--
Len Sorensen
