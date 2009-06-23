Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZFWTzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZFWTzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbZFWTza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:55:30 -0400
Received: from dan.rpsys.net ([93.97.175.187]:60197 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756020AbZFWTz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:55:29 -0400
Subject: Re: [PATCH] /drivers/video/backlight/tdo24m - crash on kmalloc
From: Richard Purdie <rpurdie@rpsys.net>
To: Aviv Laufer <aviv.laufer@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87972c700906230628l69a8a08ds4d182128bbd5dbe@mail.gmail.com>
References: <87972c700906230628l69a8a08ds4d182128bbd5dbe@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 20:53:45 +0100
Message-Id: <1245786825.26606.20.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 16:28 +0300, Aviv Laufer wrote:
> There is  a crash in tdo24m module caused by a call to kmalloc with
> the second parameter sizeof(flag) instead of flag.
> 
> Signed-off-by: Aviv Laufer <aviv.laufer@gmail.com>

Thanks, its been queued for Linus in the backlight tree.

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

