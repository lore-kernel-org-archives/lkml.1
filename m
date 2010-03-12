Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527Ab0CLTY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 14:24:58 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:36120 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934475Ab0CLTY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 14:24:57 -0500
Date: Fri, 12 Mar 2010 20:24:54 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: rtc-linux@googlegroups.com, Miguel Aguilar <miguel.aguilar@ridgerun.com>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Samuel Ortiz <sameo@linux.intel.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: DaVinci RTC driver
Message-ID: <20100312202454.2a94b6d4@linux.lan.towertech.it>
In-Reply-To: <1268420914-6731-1-git-send-email-khilman@deeprootsystems.com>
References: <1268420914-6731-1-git-send-email-khilman@deeprootsystems.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 11:08:33 -0800
Kevin Hilman <khilman@deeprootsystems.com> wrote:

> This driver was tested on a DM365 EVM by using the rtc-test application
> from the Documentation/rtc.txt.
> 
> Signed-off-by: Miguel Aguilar <miguel.aguilar@ridgerun.com>
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

 Please add an email in MODULE_AUTHOR

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

