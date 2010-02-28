Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504Ab0B1SmF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:42:05 -0500
Received: from mail.perches.com ([173.55.12.10]:1227 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932699Ab0B1SmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:42:02 -0500
Subject: Re: [PATCH] alpha: use __ratelimit
From: Joe Perches <joe@perches.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
References: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Feb 2010 10:42:00 -0800
Message-ID: <1267382520.12641.29.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-28 at 19:58 +0900, Akinobu Mita wrote:
> Replace open-coded rate limiting logic with __ratelimit().

Perhaps printk_ratelimited?


