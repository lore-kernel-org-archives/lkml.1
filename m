Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbXKUFv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbXKUFv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 00:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXKUFvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 00:51:49 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:22758 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbXKUFvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 00:51:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KnE6yWJj4483d4NbdVT8M2rh1/pd2yS/1NAMhM3Fcj+pndKWVOXeym3V7G8ZvzicnBRvG/4jt6YC5jNlL6ih5Z482a7c8U0cDbldI0hhND3braBUTJPGWYCfjMM3TGIUTX49V7fYk2KLd3q97WKb3cnXrT+cvPUPuQvIAXIri9Q=
Message-ID: <a8e1da0711202151t6c9d52acjf1f876085b95dfce@mail.gmail.com>
Date: Wed, 21 Nov 2007 13:51:47 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071120204525.ff27ac98.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, andrew

modpost failed for me:
  MODPOST 360 modules
ERROR: "empty_zero_page" [drivers/kvm/kvm.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Regards
dave
