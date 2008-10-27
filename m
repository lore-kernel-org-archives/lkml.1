Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbYJ0UUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbYJ0UUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYJ0UUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:20:01 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:12903 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbYJ0UT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PALJDTpDGErNwrAjUjPYHEFbIWZMLy4+EQm1x/CMv3i6OXQrN2wJIqRUauyiUE5BsX
         oRnwTbq3wAwp2WQ2tuijHV4Wlkr7okexkrjPnLsXzt1G9o6aYNqoOE4iUbN54sCCk9Dw
         2CeC/4RNTvL0uS+M362RJ8XUWzmDHph36wt3c=
Message-ID: <8db1092f0810271319s5d15c2ffrab37a548fa388738@mail.gmail.com>
Date: Mon, 27 Oct 2008 21:19:56 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
Cc: "Robert Hancock" <hancockr@shaw.ca>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, lenb@kernel.org, fabio.comolli@gmail.com
In-Reply-To: <8db1092f0810251151l4c7f9382r34defa6d4d6ee24c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.1HaqObZirROiyqr922A7hRDVc54@ifi.uio.no>
	 <fa.Rzh43vSl9NX1QQ2nOYQSgEJcZAw@ifi.uio.no> <49035313.9080309@shaw.ca>
	 <200810252004.01274.rjw@sisk.pl>
	 <8db1092f0810251151l4c7f9382r34defa6d4d6ee24c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/25 Maciej Rutecki <maciej.rutecki@gmail.com>:
> Suspend to ram, but another machine (previous PC, now laptop) and
> another problem:
>
> ACPI: EC: missing confirmations, switch off interrupt mode.
> ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for
> [EmbeddedControl] [20080926]
> ACPI Error (psparse-0524): Method parse/execution failed [\_TZ_.C31E]
> (Node f7019858), AE_TIME
> ACPI Error (psparse-0524): Method parse/execution failed
> [\_TZ_.TZ3_._TMP] (Node f7019ed0), AE_TIME
>
> It doesn't happened immediately after s2ram but is correlation between
> s2ram and this error.

I was wrong; it happens not only after suspend to ram but sometimes
after normal boot.


-- 
Maciej Rutecki
http://www.maciek.unixy.pl
