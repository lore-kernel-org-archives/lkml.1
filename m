Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbYDRV6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbYDRV6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYDRV6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 17:58:14 -0400
Received: from mx0.towertech.it ([213.215.222.73]:38338 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751033AbYDRV6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 17:58:13 -0400
Date: Fri, 18 Apr 2008 23:58:08 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: rtc-linux@googlegroups.com, lkml <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/6] RTC: rtc-ds1374: fix unsigned new_alarm test
Message-ID: <20080418235808.7598759f@i1501.lan.towertech.it>
In-Reply-To: <48061C0C.2020406@tiscali.nl>
References: <480558CA.7090800@tiscali.nl>
	<48061AFC.9050106@tiscali.nl>
	<48061C0C.2020406@tiscali.nl>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 17:32:28 +0200
Roel Kluin <12o3l@tiscali.nl> wrote:

> New_alarm is unsigned so the test didn't work.
>     
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

