Return-Path: <linux-kernel-owner+w=401wt.eu-S1762945AbYGBIyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762945AbYGBIyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYGBIyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:54:36 -0400
Received: from trinity.fluff.org ([89.145.97.151]:43513 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbYGBIyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:54:35 -0400
Date: Wed, 2 Jul 2008 09:54:30 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ben Dooks <ben-linux@fluff.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, lethal@linux-sh.org
Subject: Re: [patch 1/1] MFD: SM501 build fixes when CONFIG_MFD_SM501_GPIO unset.
Message-ID: <20080702085430.GR8489@trinity.fluff.org>
References: <20080702083428.963530966@fluff.org> <20080702083429.070304181@fluff.org> <486B3E9D.30205@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486B3E9D.30205@cn.fujitsu.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 04:38:53PM +0800, Li Zefan wrote:
> > Fix the build problems if CONFIG_MFD_SM501_GPIO is not set,
> > which is generally when there is no gpiolib support available
> > as currently happens on x86 when building PCI SM501.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Tested-by: Li Zefan <lizf@cn.fujitsu.com>

thanks.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

