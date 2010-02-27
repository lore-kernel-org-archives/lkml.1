Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967806Ab0B0ELm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 23:11:42 -0500
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:33842 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967768Ab0B0ELl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 23:11:41 -0500
X-Greylist: delayed 1245 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 23:11:41 EST
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201002270342.o1R3gSRb026851@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH 01/14] MAINTAINERS: update drivers/platform/x86 information
To: mjg@redhat.com (Matthew Garrett)
Date: Sat, 27 Feb 2010 14:12:28 +1030 (CST)
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg@redhat.com (Matthew Garrett), anisse@astier.eu (Anisse Astier),
       carlos@strangeworlds.co.uk (Carlos Corbacho),
       cezary.jackiewicz@gmail.com (Cezary Jackiewicz),
       corentincj@iksaif.net (Corentin Chary),
       don@syst.com.br (Daniel Oliveira Nascimento),
       laforge@gnumonks.org (Harald Welte),
       ibm-acpi@hmh.eng.br (Henrique de Moraes Holschuh),
       herton@mandriva.com.br (Herton Ronaldo Krzesinski),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       sziwan@users.sourceforge.net (Karol Kozimor),
       lenb@kernel.org (Len Brown), mzxreary@0pointer.de (Lennart Poettering),
       malattia@linux.it (Mattia Dongili), peter@piie.net (Peter Feuerer),
       sujith.thomas@intel.com (Sujith Thomas),
       cascardo@holoscopio.com (Thadeu Lima de Souza Cascardo)
In-Reply-To: <1267197527-18062-2-git-send-email-mjg@redhat.com> from "Matthew Garrett" at Feb 26, 2010 10:18:34 AM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew

> Many of the drivers/platform/x86 drivers have nothing to do with ACPI, so
> it's kind of inappropriate for them to be stuck under the ACPI mailing
> list. Add a new mailing list (platform-driver-x86@vger.kernel.org) and,
> with Len's blessing, add myself as subsystem maintainer.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> :
>  FUJITSU LAPTOP EXTRAS
>  M:	Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
> -L:	linux-acpi@vger.kernel.org
> +L:	platform-driver-x86@vger.kernel.org
>  S:	Maintained
>  F:	drivers/platform/x86/fujitsu-laptop.c

Sounds fine to me.

Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

Regards
  jonathan
