Return-Path: <linux-kernel-owner+w=401wt.eu-S1765665AbXG3OEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765665AbXG3OEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbXG3OEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:04:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:53580 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbXG3OEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=U/xANYMwmdZz3+vbr2cmd/u/AkBcPaOuMGX2CcP+8ukvwcE/08IiMnTM39xby6MXocv/MQi1ANd09PPrET31+AhVbeCWv9UIixXinpvCaT9tpWYpuGvcCWShq84wAgCjTyeVVsR2bhX+2myCV62EPpD2UJoytfSkrUhXSN/EtF0=
Message-ID: <3d8471ca0707300704wc4119c2iaf865d685324d7c@mail.gmail.com>
Date: Mon, 30 Jul 2007 16:04:37 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: 2.6.23-rc1, spamassassin vs rpc stuffs, rpc 1, spamassassin 0
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200707300957.39667.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707300957.39667.gene.heskett@gmail.com>
X-Google-Sender-Auth: 6406731871496516
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Comments anyone?

This is not specific to the kernel.
It was discussed here: http://lkml.org/lkml/2007/1/24/258
http://cyberelk.net/tim/portreserve/ seems to be the solution,
it's a pity it is not widely deployed.

Cheers.
-- 
Guillaume
