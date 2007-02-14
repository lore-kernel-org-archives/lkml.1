Return-Path: <linux-kernel-owner+w=401wt.eu-S1751165AbXBNTmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbXBNTmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXBNTmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:42:14 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:34590 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbXBNTmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:42:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=YQEsM2vwc4UtCZ9twY/YPvVxgjO1vPiIQLbCuTfyF9Z7T8niQcxTebS5kp39YmSBxZaO1Dq7T7KSIK+RWtiDcngLsDYnASZHAVANWE8NVNieZy2UPlQGaoV6dhGMiVZ0wgaS73gkeXCfN5aTH2UPD729djM+5a6jIH5VTRqEU7Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] ide/pci/delkin_cb.c: pci_module_init to pci_register_driver
Date: Wed, 14 Feb 2007 20:47:30 +0100
User-Agent: KMail/1.9.5
Cc: Mark Lord <mlord@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20070214003942.4331.78713.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20070214003942.4331.78713.sendpatchset@thinktank.campus.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702142047.31008.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wednesday 14 February 2007 01:39, Richard Knutsson wrote:
> Convert pci_module_init() to pci_register_driver().
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Compile-tested with "allyes", "allmod" & "allno" on i386

applied, thanks
