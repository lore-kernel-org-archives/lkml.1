Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381Ab0BZQkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:40:06 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:54303 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965310Ab0BZQkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:40:02 -0500
Date: Fri, 26 Feb 2010 17:39:41 +0100
From: Anisse Astier <anisse@astier.eu>
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
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
       Mattia Dongili <malattia@linux.it>, Peter Feuerer <peter@piie.net>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: Re: [PATCH 01/14] MAINTAINERS: update drivers/platform/x86
 information
Message-ID: <20100226173941.3cda7135@destiny.ordissimo>
In-Reply-To: <1267197527-18062-2-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
	<1267197527-18062-2-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Fri, 26 Feb 2010 10:18:34 -0500, Matthew Garrett <mjg@redhat.com> wrote :

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

>  
>  MSI WMI SUPPORT
>  M:	Anisse Astier <anisse@astier.eu>
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Supported
>  F:	drivers/platform/x86/msi-wmi.c
>  

Great, thanks!


>  
> @@ -6024,6 +6039,12 @@ S:	Maintained
>  F:	Documentation/x86/
>  F:	arch/x86/
>  
> +X86 PLATFORM DRIVERS
> +M:	Matthew Garrett <mjg@redhat.com>
> +L:	platform-driver-x86@vger.kernel.org
> +S:	Maintained
> +F:	drivers/platform/x86
> +
>  XEN HYPERVISOR INTERFACE
>  M:	Jeremy Fitzhardinge <jeremy@xensource.com>
>  M:	Chris Wright <chrisw@sous-sol.org>


--
Anisse
