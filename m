Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbZL1M3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbZL1M3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 07:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751192AbZL1M3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 07:29:14 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:43712 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbZL1M3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 07:29:13 -0500
Date: Mon, 28 Dec 2009 13:29:10 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 3/4] rtc: twl4030: move to request_threaded_irq
Message-ID: <20091228132910.195f495d@linux.lan.towertech.it>
In-Reply-To: <1261998172-29760-4-git-send-email-felipe.balbi@nokia.com>
References: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
	<1261998172-29760-4-git-send-email-felipe.balbi@nokia.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 13:02:51 +0200
Felipe Balbi <felipe.balbi@nokia.com> wrote:

> move to request_threaded_irq() on twl4030 children.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

