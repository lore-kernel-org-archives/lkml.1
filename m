Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0BCFfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:35:50 -0500
Received: from mail.perches.com ([173.55.12.10]:1830 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab0BCFft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:35:49 -0500
Subject: Re: [PATCH] scripts/get_maintainer.pl: add ability to read from
 STDIN
From: Joe Perches <joe@perches.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1265135412-18391-1-git-send-email-daniel@caiaq.de>
References: <1265135412-18391-1-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 21:35:47 -0800
Message-ID: <1265175347.18067.5.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 02:30 +0800, Daniel Mack wrote:
> This is useful for finding people for the Cc: list without dumping the
> patch to a file before.

Hi Daniel.

I think it's better if the dash isn't required.
I like this patch which is based on your idea.

http://patchwork.kernel.org/patch/69650/


