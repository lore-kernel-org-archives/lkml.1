Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbYHQRMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbYHQRMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYHQRMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:12:30 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:29823 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbYHQRM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vwji1dJxaXAzbqCeT5/WVrf3xKyT4EVeowEEdLydaM27xwupatnNHx7w66Znar/h0P
         cb2bKfgGtE5LK3MmRZgVgdiAENUyZpqL5l2n6QzDyZtw7k/jwSTd6E+YihAM8Qkw7Zte
         K9rOSvmSy85cnl1RxEQjx1Ku7yNgnV5XhMt7o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] xtensa: remove dead CONFIG_BLK_DEV_IDE code
Date: Sun, 17 Aug 2008 18:55:53 +0200
User-Agent: KMail/1.9.9
Cc: chris@zankel.net, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080813221907.GE7071@cs181140183.pp.htv.fi>
In-Reply-To: <20080813221907.GE7071@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171855.53521.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 August 2008, Adrian Bunk wrote:
> I don't know why this was there, but it was dead code.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
