Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYLPUzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYLPUzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYLPUzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:55:19 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:58895 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYLPUzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:55:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=WobJUgeOiA8xMhCy2CIYol8ZN7OLEROHARrpvblxvqsp2xiMKS7n+nZDTH5wvyIoka
         /8CFPlX4WmSWGmzLjU50+oVumhHlSCpybTt+CxJPt9//TCLz9vUQZ8gaWu6o3VCkd9xV
         TevstdfPr83j4Gx7+ZOF6zJvBHsB13/tfyyx4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 1/11] drivers/ide: Move a dereference below a NULL test
Date: Tue, 16 Dec 2008 21:49:29 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc6-next-20081128; KDE/4.1.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0812161611280.20444@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812161611280.20444@pc-004.diku.dk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812162149.30288.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2008, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In each case, if the NULL test is necessary, then the dereference should be
> moved below the NULL test.

applied, thanks!
