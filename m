Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296AbZIHWHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbZIHWHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZIHWHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:07:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37825 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZIHWHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vwT5Gx5ail+dKxLcUERlgxv4R0xdQUgfR76Z7M/8nF49rqbR2RRm8N7nL6DnrtjlxV
         CF+qlFxFUY28Za1i1Qsl8wuRzQ1HVO3TN0NtpmXBkzcN8bSe19jZG7dAhQWKqIP6mMna
         mUvaPFdv2VBJRQ/bbXckGZzNHqo+ojbefYW2I=
MIME-Version: 1.0
In-Reply-To: <1251987348.6735.49.camel@odin>
References: <1251982396-23790-1-git-send-email-linus.walleij@stericsson.com>
	 <1251987348.6735.49.camel@odin>
Date: Wed, 9 Sep 2009 00:07:05 +0200
Message-ID: <63386a3d0909081507n7071761fyb7c8350072129fcd@mail.gmail.com>
Subject: Re: [PATCH 1/2] AB3100 regulator support v4
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

009/9/3 Liam Girdwood <lrg@slimlogic.co.uk>:

> Samuel, are you happy for this to go via mfd for simpler merging ?
> If so :-
>
> Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>

OK with you Sam?

Linus Walleij
