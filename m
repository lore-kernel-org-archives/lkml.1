Return-Path: <linux-kernel-owner+w=401wt.eu-S1764207AbYHFP52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764207AbYHFP52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:57:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030642AbYHFP5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:57:07 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1205 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030635AbYHFP5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:57:04 -0400
Message-ID: <4899C9C9.7000107@xs4all.nl>
Date: Wed, 06 Aug 2008 17:56:57 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: cf-gps op H2200 ipaq...
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Beste mensne,

Is hier iemand die me verder kan helpen?
Ik probeer een cf gps werkend te krijgen op mijn HP H2210 ipaq.

Als de kaart wordt geplaatst zie ik in dmesg:
<5>[2334577.760000] pccard: PCMCIA card inserted into slot 0
<5>[2334577.760000] pcmcia: registering new device pcmcia0.0

en er onstaan files onder /sys/devices/platform/pxa2xx-pcmcia.0.
Ook gaat de rode led aan de zijkant van de globalsat bc337 branden

Wat moet er verder nog gebeuren om de gps te kunnen gebruiken?
udev zou b.v. met pcmcia kernel modules gaan goochelen maar die lijken
ingebakken in de 2.6.21 kernel op deze Ansgtrom 2007.12 distro.

Ik zie geen devices verschijnen of andere meldingen.
Hoe gaat het verder?

Bij voorbaat dank voor bruikbare tips!

Groeten,
Udo
