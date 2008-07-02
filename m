Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbYGBIkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbYGBIkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYGBIkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:40:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49386 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbYGBIkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:40:42 -0400
Message-ID: <486B3E9D.30205@cn.fujitsu.com>
Date: Wed, 02 Jul 2008 16:38:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org
Subject: Re: [patch 1/1] MFD: SM501 build fixes when CONFIG_MFD_SM501_GPIO
 unset.
References: <20080702083428.963530966@fluff.org> <20080702083429.070304181@fluff.org>
In-Reply-To: <20080702083429.070304181@fluff.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix the build problems if CONFIG_MFD_SM501_GPIO is not set,
> which is generally when there is no gpiolib support available
> as currently happens on x86 when building PCI SM501.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Tested-by: Li Zefan <lizf@cn.fujitsu.com>

