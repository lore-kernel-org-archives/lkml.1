Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZCZGEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZCZGEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 02:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbZCZGEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 02:04:07 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:53071 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZCZGEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 02:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uL7rWVHB6vKls2hrzeDhrcomBNSNGYGBrvUxNjqPLNEQqmAbtmCoxElu9J4jVkTsrG
         Oq/UQ0z2Xsc9WpeDujrXML404H7OpPHBhqBeYuOX55KUxcUNp+P+aqx+HGWYarFVXc0P
         qs5oU+CftyLODMLa52XjxPn4TGPDdbyhS7XbA=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.0903252206520.7962@speedy.coe.org>
References: <alpine.LNX.2.00.0903252206520.7962@speedy.coe.org>
Date: Thu, 26 Mar 2009 09:04:02 +0300
Message-ID: <aa79d98a0903252304h1fdcdef3jc81dfb5ced3abc19@mail.gmail.com>
Subject: Re: pppoe over ethernet
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Detlef Tschirschky <detlef.tschirschky@gmx.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 12:28 AM, Detlef Tschirschky
<detlef.tschirschky@gmx.de> wrote:
> Hi Peoples,
>
> after update kernel 2.6.29 i got disconnects to my ISP.
> This happens 5 - 7 times in 12 hours.
> Reconnect fails only reboot solve that.
> Never before i have this kind of problems so i did a
> downgrade to 2.6.28.8 and all works fine again.
>
> Internet:       t-online in germany, dsl 6000.
> Connectiontype: pppoe over ethernet
> Netcard:        3c905B 100BaseTX [Cy3c905B 100BaseTX [Cyclone] (rev 30)
>
> Hope that helps
>
> regards
> Pauli
>

Hi,

is it possible to see your kernel log?
