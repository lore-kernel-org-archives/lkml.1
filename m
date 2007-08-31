Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbXHaJOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbXHaJOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbXHaJO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:14:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:37093 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbXHaJO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cd3iLJpM6p4ntOkiMdxKdFB3GsmTEkwddKYcI3YjuaQfrshpBTa4TqN/okp6RRA8vUPzDqHKX7wvIr2mLRL25IGdtPoIfiL6YO19p8W6EJ21eUL07rs3uQ0RYq+A4+oPyxLKZ4JcJH7b4qBS2rDtso2Q/fuTikPuLxNMHq6GH5c=
Message-ID: <b6fcc0a0708310214u64af62cfv23893a503a166f82@mail.gmail.com>
Date: Fri, 31 Aug 2007 13:14:26 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: possible build system oddity
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200708311037.29280.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708311037.29280.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/07, Oliver Neukum <oliver@neukum.org> wrote:
> I only touched sound/usb/usbaudio.c
> Nevertheless the whole subtree und sound/ is recompiling. What's
> happening?

Not here. Do make V=2, it should say why it's recompiling.
