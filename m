Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZIPPeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZIPPeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZIPPen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:34:43 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58102 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZIPPem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:34:42 -0400
Message-ID: <4AB1058C.6080206@cs.helsinki.fi>
Date: Wed, 16 Sep 2009 18:34:36 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH v3] media: video: pwc: Use kernel's simple_strtol()
References: <84144f020909160543s38daa8ebs989b9da09802d681@mail.gmail.com> <1253109195-25915-1-git-send-email-andy.shevchenko@gmail.com>
In-Reply-To: <1253109195-25915-1-git-send-email-andy.shevchenko@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko wrote:
> From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> 
> Change own implementation of pwc_atoi() by simple_strtol(x, NULL, 10).
> 
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

Looks good to me, FWIW,

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

			Pekka
