Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZCKPAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZCKPAk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 11:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZCKPAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 11:00:31 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:2435 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753081AbZCKPAb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 11:00:31 -0400
From: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [PATCH 7/7] mmc_spi: support for non-byte-aligned cards
Date: Wed, 11 Mar 2009 16:00:05 +0100
User-Agent: KMail/1.9.10
Cc: "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <87a5b0800903110738h508aae87y7fc462d30cc89c7f@mail.gmail.com>
In-Reply-To: <87a5b0800903110738h508aae87y7fc462d30cc89c7f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200903111600.05835.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

Am Mittwoch, 11. März 2009 schrieb Will Newton:
> Are they using the same host controller? Have you tried these cards
> with a different host controller?

I have tried with 3 different spi host controllers.

> Are you clocking them particularly slow or fast?

400 KHz, 20 MHz and 25 MHz.

> A logic probe may not display any signal integrity issues you might have.

My "logic probe" is a 1 GHz leCroy DSO. 

I am doing this for money, and I am no amateur.

best regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
