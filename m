Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbYJURx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbYJURx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYJURxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:53:50 -0400
Received: from mx0.towertech.it ([213.215.222.73]:48081 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752255AbYJURxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:53:49 -0400
Date: Tue, 21 Oct 2008 19:53:45 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Mark Jackson <mpfj@mimc.co.uk>
Cc: dbrownell@users.sourceforge.net, lkml <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: Re: [PATCH v4] Add Dallas DS1390/93/94 RTC chips
Message-ID: <20081021195345.44ee74ba@i1501.lan.towertech.it>
In-Reply-To: <48FDBFF9.2020901@mimc.co.uk>
References: <48FDBFF9.2020901@mimc.co.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 12:41:45 +0100
Mark Jackson <mpfj@mimc.co.uk> wrote:

> v4 of this patch with some code tidying as per previous comments.
> Also only a single tx/rx buffer is used.
> Now uses spi_write_then_read()
> Comments changed to include extra chips in the family
> 
> This patch adds support for the Dallas DS1390/93/94 SPI RTC chip.
> 
> Signed-off-by: Mark Jackson <mpfj@mimc.co.uk>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

