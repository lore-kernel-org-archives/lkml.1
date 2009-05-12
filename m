Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZELPD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZELPD0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZELPDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:03:15 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:38644 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbZELPDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W/EvipPIVwmPVaAzJv0+VidLwQ82HIsLf2waCVw/pmzjoyMR0Z50RGdaWyY45u9Zk6
         +jwNjMUiK8ZuMgk3toVR7mjwBRBHcf+syhLRVJf2qtHxUd5BY3xsfjyIvEEWdh/Qlkai
         4GBya8eks0SFvuxITAV3OXmIL4YTT2hN0cJ/I=
MIME-Version: 1.0
In-Reply-To: <1242080334.1991.11.camel@unix>
References: <dd18b0c30905111002y4aeb2033ma2fbb2730f5acdaf@mail.gmail.com>
	 <4A089E49.7080403@gmail.com> <1242080334.1991.11.camel@unix>
Date: Tue, 12 May 2009 11:03:15 -0400
Message-ID: <b6c5339f0905120803l497131e9k7efc1b26aeb14448@mail.gmail.com>
Subject: Re: ath9k seems to be broken on 2.6.30-rc4 with a macbook pro
From: Bob Copeland <bcopeland@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 6:18 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> Cool.
> Another odd thing Ive experienced as well
> with 2.6.29-rc8 is if my iphone is
> connected to the router I'll have a hard time connecting
> to anything until I disconnect the iphone
> from the router.(my guess is the router is getting
> old).

So the iphone causes problems when connecting from another machine
with ath9k, but it works ok in other kernels, or when iphone is not
connected?  It could be related to power saving.

-- 
Bob Copeland %% www.bobcopeland.com
