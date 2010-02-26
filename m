Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966635Ab0BZX6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:58:53 -0500
Received: from smtprelay03.ispgateway.de ([80.67.29.7]:36076 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966624Ab0BZX6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:58:49 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 18:58:49 EST
References: <1267197527-18062-1-git-send-email-mjg@redhat.com> <1267197527-18062-2-git-send-email-mjg@redhat.com>
Message-ID: <cone.1267228316.100415.6107.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Anisse Astier <anisse@astier.eu>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
       Corentin Chary <corentincj@iksaif.net>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Harald Welte <laforge@gnumonks.org>,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Karol Kozimor <sziwan@users.sourceforge.net>,
       Len Brown <lenb@kernel.org>, Lennart Poettering <mzxreary@0pointer.de>,
       Mattia Dongili <malattia@linux.it>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 01/14] MAINTAINERS: update drivers/platform/x86
         information
Date: Sat, 27 Feb 2010 00:51:56 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett writes:

> Many of the drivers/platform/x86 drivers have nothing to do with ACPI, so
> it's kind of inappropriate for them to be stuck under the ACPI mailing
> list. Add a new mailing list (platform-driver-x86@vger.kernel.org) and,
> with Len's blessing, add myself as subsystem maintainer.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: Anisse Astier <anisse@astier.eu>
> Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>
> Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: Daniel Oliveira Nascimento <don@syst.com.br>
> Cc: Harald Welte <laforge@gnumonks.org>
> Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
> Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
> Cc: Karol Kozimor <sziwan@users.sourceforge.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Cc: Mattia Dongili <malattia@linux.it>
> Cc: Peter Feuerer <peter@piie.net>
> Cc: Sujith Thomas <sujith.thomas@intel.com>
> Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  MAINTAINERS |   29 +++++++++++++++++++++++++----
>  1 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2533fc4..f355d11 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -221,6 +221,7 @@ F:	drivers/net/acenic*
>  
>  ACER ASPIRE ONE TEMPERATURE AND FAN DRIVER
>  M:	Peter Feuerer <peter@piie.net>
> +L:	platform-driver-x86@vger.kernel.org
>  W:	http://piie.net/?section=acerhdf
>  S:	Maintained
>  F:	drivers/platform/x86/acerhdf.c

Acked-by: Peter Feuerer <peter@piie.net>
