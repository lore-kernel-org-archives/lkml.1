Return-Path: <linux-kernel-owner+w=401wt.eu-S933669AbZGQACJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbZGQACJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933232AbZGQACJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:02:09 -0400
Received: from mail-pz0-f197.google.com ([209.85.222.197]:51435 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297AbZGQACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:02:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i87twHXyvADZm8VINOPV/UncFv4LBEs3f/SzE4LT+pzxMyxt9Qfdr0leGZKADYzLfi
         aeTHeu4v3YUjwgYJxaLLjcy4DFsSizVBCMPT/9+NgA/QrW0D4SjOpqTGDzyJtxjpiKpA
         6zFXVBXJIFPqo+xENeJ/dod6Bj/dVUDMNTjLE=
MIME-Version: 1.0
In-Reply-To: <1247328467-24985-1-git-send-email-tom.leiming@gmail.com>
References: <1247328467-24985-1-git-send-email-tom.leiming@gmail.com>
Date: Fri, 17 Jul 2009 08:02:08 +0800
Message-ID: <d82e647a0907161702v19b4b3f2j44ea9b051eef9e18@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM:dma-mapping:Support DMA-API debugging facility on 
	ARM
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King <rmk@arm.linux.org.uk>, linux@arm.linux.org.uk,
       joerg.roedel@amd.com
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/12  <tom.leiming@gmail.com>:
> Hi,
> This patch set introduces dma-api debugging facility on ARM, and is
> against -rc2-next tree.
>

Hi, Russell and All,

Care to give any suggestions or objections on the patches?

thanks.

-- 
Lei Ming
