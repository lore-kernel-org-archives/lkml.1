Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYKCM0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYKCM0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 07:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYKCM0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 07:26:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:17107 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbYKCM0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 07:26:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=b+yAFqUiDXrapM6UccJkQmmgqmu19/irvLd8qLOg7kCjxA7YHx31C6hB4EN0dSsVA0
         StULMkwn/OnrsgMrdTzrgtx9AN+Ejyikm6+YnWy5osZy7oP9Q2NOG9ex+xRtu9b9zT5n
         Wfx2MsJU4yqVeiavtLVt0SMYAcHVES5jS/Tbo=
Message-ID: <490EEDDD.4010203@gmail.com>
Date: Mon, 03 Nov 2008 15:26:05 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Robert Hancock <hancockr@shaw.ca>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "fabio.comolli@gmail.com" <fabio.comolli@gmail.com>
Subject: Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
References: <fa.1HaqObZirROiyqr922A7hRDVc54@ifi.uio.no>	 <fa.Rzh43vSl9NX1QQ2nOYQSgEJcZAw@ifi.uio.no> <49035313.9080309@shaw.ca>	 <200810252004.01274.rjw@sisk.pl>	 <8db1092f0810251151l4c7f9382r34defa6d4d6ee24c@mail.gmail.com>	 <8db1092f0810271319s5d15c2ffrab37a548fa388738@mail.gmail.com>	 <1225187050.5189.146.camel@yakui_zhao.sh.intel.com>	 <8db1092f0810281245k14555e26w30547cf17fde534f@mail.gmail.com> <8db1092f0811030406i48150022gb5b444710d749b43@mail.gmail.com>
In-Reply-To: <8db1092f0811030406i48150022gb5b444710d749b43@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> Problem still exists on 2.6.28-rc3:
> ACPI: EC: missing confirmations, switch off interrupt mode.
> ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for
> [EmbeddedControl] [20080926]
> ACPI Error (psparse-0524): Method parse/execution failed [\_TZ_.C31E]
> (Node f7019858), AE_TIME
> ACPI Error (psparse-0524): Method parse/execution failed
> [\_TZ_.TZ3_._TMP] (Node f7019ed0), AE_TIME
>
> But I don't see any functional problems.
>
> Regards
>   
please see #11917
