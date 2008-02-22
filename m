Return-Path: <linux-kernel-owner+w=401wt.eu-S1765084AbYBVHwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765084AbYBVHwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYBVHwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:52:07 -0500
Received: from sacred.ru ([62.205.161.221]:37441 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321AbYBVHwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:52:06 -0500
Message-ID: <47BE7F09.5060706@openvz.org>
Date: Fri, 22 Feb 2008 10:51:37 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: menage@google.com, akpm@linux-foundation.org
CC: balbir@in.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] ResCounter: Use read_uint in memory controller
References: <20080221203518.544461000@menage.corp.google.com> <20080221205525.349180000@menage.corp.google.com>
In-Reply-To: <20080221205525.349180000@menage.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 22 Feb 2008 10:51:32 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> Update the memory controller to use read_uint for its
> limit/usage/failcnt control files, calling the new
> res_counter_read_uint() function.
> 
> Signed-off-by: Paul Menage <menage@google.com>

Acked-by: Pavel Emelyanov <xemul@openvz.org>

