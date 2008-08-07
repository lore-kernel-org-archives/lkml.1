Return-Path: <linux-kernel-owner+w=401wt.eu-S1751928AbYHGMyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbYHGMyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYHGMyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:54:17 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58398 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751708AbYHGMyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:54:15 -0400
X-Return-Path: <amol.lad@gmail.com>
DomainKey-Signature: a=rsa-sha1; c=nofws; d=gmail.com; s=gamma;
	h=message-id:date:from:to:subject:in-reply-to:mime-version
	:content-type:content-transfer-encoding:content-disposition
	:references;
	b=qoi/gUNJxwoZVv3RHiIJMfcZTM4tbdIvcUQhQHwxFkwRV1ZqDX6I8HUnUmHaTNlkmC
	CHuB3z9L7xUPUoMsfhKsGHuhpsM3nstwXjy1jz36+mKWp0wYE6gJss1wlrNTDC5xGCJu
	xkUwWTMbY+Cmy2O/pVZPBlH8la7gCTpF1OOog=
Message-ID: <8c675e9b0808070427v42a4055bwae3adfb160a4e1ab@mail.gmail.com>
Date: Thu, 7 Aug 2008 16:57:30 +0530
From: "Amol Lad" <amol.lad@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: kernel command line from u-boot
In-Reply-To: <Pine.LNX.4.64.0808071050280.9798@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8c675e9b0808062141s74f1a7bfob5cab6b23b0268d3@mail.gmail.com>
	<Pine.LNX.4.64.0808071050280.9798@vixen.sonytel.be>
X-Spambayes-Classification: ham; 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Probably nobody noticed as this part of the code takes care of the
> `obsolete-style' parameters. `module_param' is the new way.

Ohh, btw how module_param is different from obsolete style paramaters
? Do we need to pass arguments to kernel from bootloader using a
different method for getting them processed using module_param ?

>
> Geert Uytterhoeven

Thanks
Amol
