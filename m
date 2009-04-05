Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbZDEAui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbZDEAui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 20:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZDEAuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 20:50:25 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:47007 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbZDEAuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 20:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=qbObOwsFmrsSFXWy7EVt2fzvgoYALcFmn/0/c6gAmPLpTad6JFACqN88RNTj+zZU1i
         6djfKbgkcf/kER1XKCSbQ+PdW00ZfUg+qCdLh8P0CGB+RImvzcnW2EGG5uDLxVDH06vM
         tSfdTWspu0rxJC2PPij2MWrwP12aaVlqvd+U0=
MIME-Version: 1.0
In-Reply-To: <20090329152334.GA11056@orion>
References: <20090329152334.GA11056@orion>
Date: Sun, 5 Apr 2009 04:50:21 +0400
Message-ID: <a4423d670904041750i194b4351ib08cd18f4a5b7394@mail.gmail.com>
Subject: Re: [PATCH 1/10] Staging: at76: convert to netdev_ops
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/29 Alexander Beregalov <a.beregalov@gmail.com>:
>
>
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Greg, these patches fix build failures when CONFIG_COMPAT_NET_DEV_OPS
is not set.
I think they should be in 2.6.30 also.
