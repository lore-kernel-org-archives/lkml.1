Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbYK3Aj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbYK3Aj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 19:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753272AbYK3Ajt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 19:39:49 -0500
Received: from mx0.towertech.it ([213.215.222.73]:57692 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753172AbYK3Ajs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 19:39:48 -0500
Date: Sun, 30 Nov 2008 01:39:31 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Hannes Eder <hannes@hanneseder.net>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] rtc-stk17ta8: fix sparse warning
Message-ID: <20081130013931.1b48f892@i1501.lan.towertech.it>
In-Reply-To: <49304ffd.09a1660a.30b3.ffffc7a7@mx.google.com>
References: <49304ffd.09a1660a.30b3.ffffc7a7@mx.google.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 17:11:47 +0100
Hannes Eder <hannes@hanneseder.net> wrote:

> Fix this sparse warning:
> 
>   drivers/rtc/rtc-stk17ta8.c:403:2: warning: returning void-valued expression
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

