Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbYKCMGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbYKCMGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 07:06:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYKCMGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 07:06:25 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:44596 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbYKCMGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 07:06:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JMbZN8n7zAmB5Phn6+A5nOi1nyBN16FRcSc6iD/1ZuOY3R/m+ljudUP0AHo6bqqPlA
         ACcHahImGo/tU8L9gOx/ggGVulnNlossN1dA+FMu0qpQrJD0pQrmlosoLekNenMiUgyF
         ukQCn7V/JWgB29L1gJ/INj+iogEK7nOhm7n6g=
Message-ID: <8db1092f0811030406i48150022gb5b444710d749b43@mail.gmail.com>
Date: Mon, 3 Nov 2008 13:06:22 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: "Zhao Yakui" <yakui.zhao@intel.com>
Subject: Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Robert Hancock" <hancockr@shaw.ca>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "fabio.comolli@gmail.com" <fabio.comolli@gmail.com>
In-Reply-To: <8db1092f0810281245k14555e26w30547cf17fde534f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.1HaqObZirROiyqr922A7hRDVc54@ifi.uio.no>
	 <fa.Rzh43vSl9NX1QQ2nOYQSgEJcZAw@ifi.uio.no> <49035313.9080309@shaw.ca>
	 <200810252004.01274.rjw@sisk.pl>
	 <8db1092f0810251151l4c7f9382r34defa6d4d6ee24c@mail.gmail.com>
	 <8db1092f0810271319s5d15c2ffrab37a548fa388738@mail.gmail.com>
	 <1225187050.5189.146.camel@yakui_zhao.sh.intel.com>
	 <8db1092f0810281245k14555e26w30547cf17fde534f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem still exists on 2.6.28-rc3:
ACPI: EC: missing confirmations, switch off interrupt mode.
ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for
[EmbeddedControl] [20080926]
ACPI Error (psparse-0524): Method parse/execution failed [\_TZ_.C31E]
(Node f7019858), AE_TIME
ACPI Error (psparse-0524): Method parse/execution failed
[\_TZ_.TZ3_._TMP] (Node f7019ed0), AE_TIME

But I don't see any functional problems.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
