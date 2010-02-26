Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966306Ab0BZVxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:53:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:5649 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466Ab0BZVxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:53:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ULukUWCaHZZ804IZcmYfSzyYSvLPSNhMTDiMAcEZ4K6xfbJO/Z3N10EoRT/zRUSptn
         1USm9BuXeSjaVX4WCpPckt0TUjqnp51Rnrb2b7LgOIoMUr5Sc0og6bUDs+7WX8LCOHhv
         uiKCMun05HeL5jiiHQDXvMK5rxTN1Kar8XSCc=
MIME-Version: 1.0
In-Reply-To: <1267197527-18062-2-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
	 <1267197527-18062-2-git-send-email-mjg@redhat.com>
Date: Fri, 26 Feb 2010 22:53:01 +0100
Message-ID: <71cd59b01002261353w53fea6cax146acfd18e87636@mail.gmail.com>
Subject: Re: [PATCH 01/14] MAINTAINERS: update drivers/platform/x86 
	information
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Anisse Astier <anisse@astier.eu>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26, 2010 at 4:18 PM, Matthew Garrett <mjg@redhat.com> wrote:
> Many of the drivers/platform/x86 drivers have nothing to do with ACPI, so
> it's kind of inappropriate for them to be stuck under the ACPI mailing
> list. Add a new mailing list (platform-driver-x86@vger.kernel.org) and,
> with Len's blessing, add myself as subsystem maintainer.

Ok,
Should I re-send the big asus-laptop series I sent to Len (not already
in acpi tree)
and send it back to you so it can be merged in platform-driver-x86 ?

-- 
Corentin Chary
http://xf.iksaif.net
