Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab0BPJDx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 04:03:53 -0500
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63595 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab0BPJDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 04:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K4SbW1di1ViYk+yDbc+0wbD2+CbS3DQ3VGM4Pcit6jPcbJLSCYIXOuAGaBUzUUqLe2
         69zn7lbrjQA1BC9SZ/W79n8bv6tX39DNEj6nWHz8dv4n2jtDBjIK4PM3lLAe0K9Py6nU
         sBscRWFTXWYaG3mXJBKEklGNNCF3rBnTX3xx0=
MIME-Version: 1.0
In-Reply-To: <20100216084110.GK21783@one.firstfloor.org>
References: <bec9a5871002160035v63cce8ck9ecb9252b2f162a6@mail.gmail.com>
	 <20100216084110.GK21783@one.firstfloor.org>
Date: Tue, 16 Feb 2010 11:03:49 +0200
Message-ID: <bec9a5871002160103t17c36599w13f18d79cc84e539@mail.gmail.com>
Subject: Re: Reading /dev/mem by dd
From: Nameer Yarkon <nameer.yarkon@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Robert Hancock <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 16, 2010 at 10:41 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Modern X does it through kernel modules (DRM, GEM etc.)

is it done by an mmap call (to the device) ?

> One reason it's needed to do it this way is IOMMUs.

why would it care about IOMMUs ? do graphic cards manipulate the memory too ?

thank you!

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only.
>
