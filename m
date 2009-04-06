Return-Path: <linux-kernel-owner+w=401wt.eu-S1757139AbZDFRLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbZDFRLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 13:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZDFRK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 13:10:59 -0400
Received: from mx0.towertech.it ([213.215.222.73]:39831 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752172AbZDFRK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 13:10:58 -0400
Date: Mon, 6 Apr 2009 19:10:53 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: anemo@mba.ocn.ne.jp, Alessandro Zummo <a.zummo@towertech.it>,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH] rtc-tx4939: Drop IRQF_SHARED
Message-ID: <20090406191053.740229a8@i1501.lan.towertech.it>
In-Reply-To: <1239036633-10032-3-git-send-email-anemo@mba.ocn.ne.jp>
References: <1239036633-10032-3-git-send-email-anemo@mba.ocn.ne.jp>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Apr 2009 01:50:33 +0900
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> IRQF_SHARED should be used with IRQF_DISABLED.  This RTC have dedicated
> irq line so there is no reason to use IRQF_SHARED.

 Is that true for every board this rtc is/will be used on?

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

