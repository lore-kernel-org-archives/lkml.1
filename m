Return-Path: <linux-kernel-owner+w=401wt.eu-S933413AbXEFJX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbXEFJX1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 05:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933463AbXEFJX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 05:23:27 -0400
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:1080 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933413AbXEFJX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 05:23:26 -0400
Date: Sun, 6 May 2007 11:24:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jordan Crouse <jordan.crouse@amd.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>, Bryan Wu <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org,
       Christer Weinigel <wingel@nano-system.com>
Subject: Re: Bitbanging i2c bus driver using the GPIO API
Message-ID: <20070506112437.7d432a1c@hyperion.delvare>
In-Reply-To: <20070427185331.GG5577@csclub.uwaterloo.ca>
References: <20070420194933.0813a359@hyperion.delvare>
	<20070422154151.GJ5575@csclub.uwaterloo.ca>
	<20070423114254.71787844@hyperion.delvare>
	<20070423144710.GD1372@cosmic.amd.com>
	<20070426145634.3ac2b7a3@hyperion.delvare>
	<20070426132905.GP5575@csclub.uwaterloo.ca>
	<20070426133920.GA25456@cosmic.amd.com>
	<20070426140323.GE5577@csclub.uwaterloo.ca>
	<20070427100204.403d068c@hyperion.delvare>
	<20070427144949.GD28203@cosmic.amd.com>
	<20070427185331.GG5577@csclub.uwaterloo.ca>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 14:53:31 -0400, Lennart Sorensen wrote:
> scx200_i2c does depend on i2c-algo-bit so there is really very little
> code inside scx200_i2c itself.  Does the new driver replace
> i2c-algo-bit as well or does it use it?

It uses it.

-- 
Jean Delvare
