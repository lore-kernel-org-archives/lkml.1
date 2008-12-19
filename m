Return-Path: <linux-kernel-owner+w=401wt.eu-S1752641AbYLSULu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbYLSULu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYLSULi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:11:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:13757 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYLSULh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=whtv2DEY09wK2S+mg4bYqKwQeSD5caNziRYeKmYMSyY3eRJD8hSdMsp5QkIGRBgIUS
         /s12aH9Lq269+/aao778RPX58P4RJstHSNSHWnnjY5gsc3/O23fxRZnDa5MxdGAxLDDn
         cWnHWilV88O7Sgc50dEhIu72PB5uvYkOqaky4=
Message-ID: <3f9a31f40812191211x12fc08cateb3502c6765d0c4c@mail.gmail.com>
Date: Sat, 20 Dec 2008 01:41:36 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Ben Hutchings" <bhutchings@solarflare.com>
Subject: Re: Firmware patches for Network
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, "Jeff Garzik" <jeff@garzik.org>,
       "David Woodhouse" <dwmw2@infradead.org>, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org
In-Reply-To: <1229715971.3097.6.camel@achroite>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40812191131m48802157r596d7773fb435f34@mail.gmail.com>
	 <1229715971.3097.6.camel@achroite>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ben,

On Sat, Dec 20, 2008 at 1:16 AM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
>> 3. git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
>
> This one.
>

4 out of 10 Networking's firmware patches are already floating in
linux-next from long time :

1. firmware: convert e100 driver to request_firmware()
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=c98e632b660ef49b67a9591040230b518785e38a
2. firmware: convert acenic driver to request_firmware()
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=e39c0e190f52331b35931fbe5e34a07114d66171
3. firmware: convert tg3 driver to request_firmware()
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=aadd3ed38a6745e21dc8d2f388bbba42ead0a085
4. starfire: use request_firmware()
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=df3eea674103ce451357be8eb873092943ad3551

Should I need to resend all 10 or remaining 6.

Thank you,

Jaswinder Singh.
