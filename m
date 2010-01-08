Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725Ab0AHPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0AHPOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456Ab0AHPOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:14:19 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:36379 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab0AHPOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:14:18 -0500
Date: Fri, 08 Jan 2010 16:14:14 +0100
Message-Id: <537531092@web.de>
MIME-Version: 1.0
From: Peter Paul <abnominales@web.de>
To: linux-kernel@vger.kernel.org
Subject: =?iso-8859-15?Q?ACPI_quirks_-_acpi=5Fosi=3D"!Windows_2006"_required_on?=
 =?iso-8859-15?Q?_FSC_Amilo_notebooks_to_enable_brightness_keys?=
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+d8/4+Qbnz5R87rYoAyyIqmO5ouoHkA7gd7udlsyDL8Bue+
 SsynQbiPt4k2+b22U6UMBEE6PtjDYnV0GMSnNhG0lC4aZe+nqIl7VPPf6usq
 g==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brightness control keys (Fn+F7 & Fn+F8) only work when adding this boot parameter.
They do not create any events for the OS but work even when in BIOS or GRUB, but not in Linux without said kernel parameter.
Userspace tools are able controlling brightness using standard methods regardless of any ACPI parameters, they only seem to affect the keys themselves.

Forum reports state that this is true for the whole Fujitsu (Simens) Amilo series, tested on Amilo Pi 2515.
___________________________________________________________
Preisknaller: WEB.DE DSL Flatrate für nur 16,99 Euro/mtl.! 
http://produkte.web.de/go/02/

