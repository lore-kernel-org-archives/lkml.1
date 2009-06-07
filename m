Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbZFGNp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbZFGNp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZFGNpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:45:04 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33552 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbZFGNo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=LQJLpahD3Cf8vGGU3LKPsFanZlZPQj7WsO4oG9hGdqdOfGpd6Y9B2utW8cIW54xUfZ
         fZLwUxR+OwhpC9sUP5biphYztC6inciDMmKMUoj+2fxn8ftrcTlTkE8GdZ+7UgbVAlEU
         huYKJSaj9gLRk/ALEOFhOvYlE9e9hJKV1vNEk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: rename CONFIG_LBD to CONFIG_LBDAF
Date: Sun, 7 Jun 2009 15:39:10 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090605-07377-g5acd34e; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <200904251714.52020.bzolnier@gmail.com>
In-Reply-To: <200904251714.52020.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906071539.10701.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 April 2009 17:14:50 Bartlomiej Zolnierkiewicz wrote:
> Follow-up to "block: enable by default support for large devices
> and files on 32-bit archs".
> 
> Rename CONFIG_LBD to CONFIG_LBDAF to:
> - allow update of existing [def]configs for "default y" change
> - reflect that it is used also for large files support nowadays
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

ping?
