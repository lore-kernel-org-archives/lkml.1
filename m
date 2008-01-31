Return-Path: <linux-kernel-owner+w=401wt.eu-S933504AbYAaUhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504AbYAaUhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 15:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762196AbYAaUhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 15:37:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55274 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759127AbYAaUhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 15:37:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Giacomo Catenazzi <cate@cateee.net>
Subject: Re: kernel bug at drivers/ide/ide-cd.c:1726 on lastest git
Date: Thu, 31 Jan 2008 21:34:32 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <47A21195.8000401@cateee.net>
In-Reply-To: <47A21195.8000401@cateee.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801312134.33061.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 31 of January 2008, Giacomo Catenazzi wrote:
> I've a kernel bug since few days, but I've not yet had time to bisect.
> 
> The output is in:
> http://cateee.net/kernel/dsc00169.jpg

Known issue, see http://lkml.org/lkml/2008/1/29/140 and the following thread.

Thanks,
Rafael
