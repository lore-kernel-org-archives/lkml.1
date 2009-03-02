Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbZCBLrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbZCBLrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 06:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZCBLrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 06:47:41 -0500
Received: from mx0.towertech.it ([213.215.222.73]:60773 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752103AbZCBLrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 06:47:40 -0500
Date: Mon, 2 Mar 2009 12:47:37 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Mike Rapoport <mike@compulab.co.il>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, raph@8d.com
Subject: Re: [PATCH] rtc-v3020: add ability to access v3020 chip with GPIOs
Message-ID: <20090302124737.03075958@i1501.lan.towertech.it>
In-Reply-To: <d2392eac1d61487c6e56341271e7ba10c16b94b9.1235400430.git.mike@compulab.co.il>
References: <cover.1235400430.git.mike@compulab.co.il>
	<d2392eac1d61487c6e56341271e7ba10c16b94b9.1235400430.git.mike@compulab.co.il>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Mar 2009 13:40:57 +0200
Mike Rapoport <mike@compulab.co.il> wrote:

> The v3020 RTC can be connected to GPIOs as well as to memory-like interface.
> Add ability to use GPIO bit-bang for v3020 read-write access.
> 
> Signed-off-by: Mike Rapoport <mike@compulab.co.il>

 For the rtc part you have my 

 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

 please send the patch to the GPIO maintainer . Once you
 have his Acked-by and the one of the driver's author you can
 send it to Andrew for inclusion.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

