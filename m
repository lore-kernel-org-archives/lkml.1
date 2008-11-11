Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYKKChN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYKKChN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 21:37:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYKKChA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 21:37:00 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:30552 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYKKCg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 21:36:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eq2nZswH0tBt6211U9vyNaIbFkGZedQmLCDJ6qO05TsV18q9pFfyMidMv+yx9J9WGT
         tIiPwDW2yS+mcFZexsfQDKVtp2P1KJKzehgK2/2EXMoNEvoENudyHzqArwRlQDIUctnZ
         juI9MsjzC5gITAyLeU68WsO4LV2xvt9juKjDQ=
Message-ID: <e38d12ff0811101836s6f1d9449v4c210f2b83169e46@mail.gmail.com>
Date: Mon, 10 Nov 2008 21:36:57 -0500
From: "Andrey Vul" <andrey.vul@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about CardBus support and ExpressCard?
In-Reply-To: <e38d12ff0811101834u46065e0ft13325cbb0104f36b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e38d12ff0811101834u46065e0ft13325cbb0104f36b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 21:34, Andrey Vul <andrey.vul@gmail.com> wrote:
> I'm configuring 26.27.2 right now and my laptop supports ExpressCard
> but not CardBus?
> Do I still need CardBus kernel support for the ExpressCard slot to
> function properly?
Apart from PCI Express hotplug.
