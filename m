Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbYAFP5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbYAFP5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 10:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYAFP46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 10:56:58 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:1414 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754209AbYAFP45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 10:56:57 -0500
Date: Sun, 6 Jan 2008 16:56:52 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, i2c@lm-sensors.org
Subject: Re: [PATCH 2/7] i2c : convert semaphore to mutex in struct class
Message-ID: <20080106165652.563b6423@hyperion.delvare>
In-Reply-To: <20080103055441.GC4885@darkstar.te-china.tietoenator.com>
References: <20080103055441.GC4885@darkstar.te-china.tietoenator.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008 13:54:41 +0800, Dave Young wrote:
> Use mutex instead of semaphore in struct class.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 
> ---
> drivers/i2c/i2c-core.c |    9 ++++-----
> 1 file changed, 4 insertions(+), 5 deletions(-)

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
