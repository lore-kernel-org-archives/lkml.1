Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbXI1LTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbXI1LTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXI1LS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:18:58 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:47202 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbXI1LS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CBRbBdPICIj9mPHVjXRlewXrZjF2FJG+sIIy/P+lEozR3sGEZDAOE8GBPSzfkRlyAyyDJhBT2qBz3k4v5W1bgk0ldOnip24LcgGpS3JGAhkDdf0ncTsxSaKEyuQ4DVd0LGpk23BsQaLd67L3JACz1lTlAq4s6OmshdCwfKsbpqg=
Message-ID: <653402b90709280418i3c3de2a2h82760abc26decb14@mail.gmail.com>
Date: Fri, 28 Sep 2007 13:18:54 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: bil@beeb.net
Subject: Re: Problem with booting new kernel on Toshiba Equium Laptop
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200709281108.46947.bil@beeb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709281108.46947.bil@beeb.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/07, bill purvis <bil@beeb.net> wrote:
>
> I'm not a kernel guru at all, and I'd really appreciate anyone
> who can offer me advice on how to figure out what's going on.
>

Bill, this list is just about kernel development.

Usually, if your screen just got blank, it means you didn't add a
necessary module for your computer. Your best bet is to read "Linux
Kernel in a Nutshell", by Greg KH: http://www.kroah.com/lkn/

Specially, Chapter 7: Customizing a Kernel.

Then, if your screen still gets black and you think it is a kernel
bug, report it.

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
