Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbYLIXA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbYLIXA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbYLIXAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:00:12 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:43094 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYLIXAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:00:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YeOVurz1LTy+aQN1U/QtmTo/C7W/9qXGXbq93awjX0Aqb92WuZwedCtWWMdNHvCBbs
         2K78EtptcP8zULK/Ye8rfKZoTfvYxppUjm6PuizIDHCUQA8rOTu4Wgtc+zAZGn5fnVcv
         UxLN01+O0P5QTU6KqP64otXVAcIlFCd5bwZ5k=
Message-ID: <25e057c00812091453r79884cb7oa19224aa9e4d12fd@mail.gmail.com>
Date: Tue, 9 Dec 2008 23:53:27 +0100
From: "roel kluin" <roel.kluin@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH 12/33] i2c: Make static
Cc: linux-i2c@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20081209200409.17fac29f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493EA286.7080500@gmail.com> <493EBBD0.6070201@gmail.com>
	 <20081209200409.17fac29f@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Nack:
>
> drivers/i2c/i2c-core.c:EXPORT_SYMBOL(i2c_smbus_process_call);
>
> --
> Jean Delvare
>

Again thanks for reporting, fortunately it appears that this only occurred
in a few other patches.

Roel
