Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbYEWKTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbYEWKTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 06:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYEWKTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 06:19:04 -0400
Received: from mx0.towertech.it ([213.215.222.73]:34231 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751111AbYEWKTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 06:19:03 -0400
Date: Fri, 23 May 2008 12:18:58 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: Push BKL for ioctl down into the rtc drivers
Message-ID: <20080523121858.20502f82@i1501.lan.towertech.it>
In-Reply-To: <20080522220031.03d635d8@core>
References: <20080522220031.03d635d8@core>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 22:00:31 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Signed-off-by: Alan Cox <alan@redhat.com>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

