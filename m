Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbYIEHuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbYIEHuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 03:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYIEHuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 03:50:10 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:9320 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYIEHuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 03:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VRcn0/cNIBB69k+FYvCLy/2XNIWb62DbZdKGN5BMJI3MW35UNdBmghiBJh/UT1YvKU
         2NerRHFE40u9waXx42xa4Wqkj5m3REqJLBYkDDmLRN/bg7JNaBx+QJeaP6rsOsizw3Ik
         wA1bPJJzv6zCR/YZoACgJcTxoylgiUFiXRHok=
Message-ID: <a4423d670809050050r148df4e8md85774714b1e46ee@mail.gmail.com>
Date: Fri, 5 Sep 2008 11:50:06 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.27-rc5-mm1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080904224004.d3dd3076.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080904224004.d3dd3076.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/5 Andrew Morton <akpm@linux-foundation.org>:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.27-rc5/2.6.27-rc5-mm1/
Hi Andrew

2.6.27-rc5-mm1.gz seems broken
gzip: 2.6.27-rc5-mm1.gz: unexpected end of file
The result does not contain drivers/net/wireless/libertas_tf/

gpg sign seems good
