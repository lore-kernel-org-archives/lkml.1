Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab0CCPT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:19:26 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:40578 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab0CCPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:19:25 -0500
Date: Wed, 3 Mar 2010 16:19:20 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: james@albanarts.com, Paul Gortmaker <p_gortmaker@yahoo.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] rtc-coh901331: Fix braces in resume code.
Message-ID: <20100303161920.2dbdb3f7@linux.lan.towertech.it>
In-Reply-To: <6a4b170b1003030355p44dd277fpedae0da7a76ed739@mail.gmail.com>
References: <6a4b170b1003030355p44dd277fpedae0da7a76ed739@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 11:55:15 +0000
James Hogan <james@albanarts.com> wrote:

> The else part of the if statement is indented but does not have braces
> around it. It clearly should since it uses clk_enable and clk_disable
> which are supposed to balance.
> 
> Signed-off-by: James Hogan <james@albanarts.com>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

