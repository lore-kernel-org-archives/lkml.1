Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbZBHS32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbZBHS32 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZBHS3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:29:20 -0500
Received: from mx0.towertech.it ([213.215.222.73]:52640 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752976AbZBHS3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:29:19 -0500
Date: Sun, 8 Feb 2009 19:29:16 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: mano@roarinelk.homelinux.net, rtc-linux@googlegroups.com,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [PATCH] rtc: t reaches -1, tested 0
Message-ID: <20090208192916.04acdc33@i1501.lan.towertech.it>
In-Reply-To: <498EE7D6.4090100@gmail.com>
References: <498EE7D6.4090100@gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Feb 2009 15:10:30 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> With a postfix decrement t will reach -1 rather than 0,
> so the warning nor errot_out occur.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

