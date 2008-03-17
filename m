Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYCQJ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYCQJ7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYCQJ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:59:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55211 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYCQJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:59:40 -0400
Date: Mon, 17 Mar 2008 18:59:13 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "S.Ca?lar Onur" <caglar@pardus.org.tr>
Subject: Re: [PATCH] arch/ia64/kernel/: Use time_* macros
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
References: <1205746593-24820-1-git-send-email-caglar@pardus.org.tr> <1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
Message-Id: <20080317185712.7B4A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

nice clean up.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.
> 
> So following patch implements usage of the time_after() & time_before() macros, defined at linux/jiffies.h, which deals with wrapping correctly




