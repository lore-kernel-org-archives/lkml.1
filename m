Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbYHHQnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbYHHQnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758858AbYHHQkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:40:24 -0400
Received: from mx0.towertech.it ([213.215.222.73]:49605 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758835AbYHHQkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:40:22 -0400
Date: Fri, 8 Aug 2008 18:40:19 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Adrian Bunk <bunk@kernel.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [6/17] rtc: use bcd2bin/bin2bcd
Message-ID: <20080808184019.3c9528e4@i1501.lan.towertech.it>
In-Reply-To: <20080808163443.GM14495@cs181140183.pp.htv.fi>
References: <20080808163443.GM14495@cs181140183.pp.htv.fi>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 19:34:43 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> This patch changes various rtc related code to use the
> new bcd2bin/bin2bcd functions instead of the obsolete 
> BCD_TO_BIN/BIN_TO_BCD/BCD2BIN/BIN2BCD macros.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>
-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

