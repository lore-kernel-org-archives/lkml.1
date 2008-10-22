Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbYJVRyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbYJVRyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYJVRyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:54:15 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:24702 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYJVRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:54:14 -0400
X-Spam-Flag: NO
X-Spam-Score: -9.389
Message-ID: <48FF68BF.6070201@tremplin-utc.net>
Date: Wed, 22 Oct 2008 19:54:07 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20080929 Mandriva/2.0.0.17-2mdv2009.0 (2009.0) Thunderbird/2.0.0.17 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Yan Burman <burman.yan@gmail.com>, Pau Oliva Fora <pau@eslack.org>
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver
References: <20081022154459.GA26291@elf.ucw.cz>
In-Reply-To: <20081022154459.GA26291@elf.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek schreef:
> This driver was first written by Yan Burman. Eric Piel has updated it
> and slimed it up (including the removal of an interface to access to
> the free-fall feature of the sensor because it is not reliable enough
> for now). Pavel Machek removed few more features and switched locking
> from semaphore to mutex.

I wa planning to update the patch this evening, but Pavel beat me at it.
Thanks.

Acked-by: Eric Piel <eric.piel@tremplin-utc.net>

See you,
Eric
