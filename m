Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0BBIVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:21:31 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:37162 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab0BBIVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:21:25 -0500
MIME-Version: 1.0
In-Reply-To: <bf8e8f72e7c2da124daebc9e96f1236e34badbca.1265095094.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com> <bf8e8f72e7c2da124daebc9e96f1236e34badbca.1265095094.git.joe@perches.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 2 Feb 2010 01:21:05 -0700
X-Google-Sender-Auth: 807a95acd23debc1
Message-ID: <fa686aa41002020021p1bac7116o9911e14e62da059a@mail.gmail.com>
Subject: Re: [PATCH 07/10] drivers/spi/spi_s3c64xx.c: Fix continuation line 
	formats
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 12:22 AM, Joe Perches <joe@perches.com> wrote:
> String constants that are continued on subsequent lines with \
> are not good.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Merged into next-spi, thanks.

g.
