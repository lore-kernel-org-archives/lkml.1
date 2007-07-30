Return-Path: <linux-kernel-owner+w=401wt.eu-S967365AbXG3RPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967365AbXG3RPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966059AbXG3RPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:15:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966026AbXG3RPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:15:10 -0400
Message-ID: <46AE1C9C.90907@anagramm.de>
Date: Mon, 30 Jul 2007 19:15:08 +0200
From: Clemens Koller <clemens.koller@anagramm.de>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: shacky <shacky83@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: k8temp on 2.6.18
References: <7fedbc910707300638w4ac174edleb7a6eac2104cb85@mail.gmail.com>
In-Reply-To: <7fedbc910707300638w4ac174edleb7a6eac2104cb85@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1/8Xzupdtsf+Azrjlj98g1+SVae6SaW1878GEE
 1bGNvwSmFCrnUrfforgx2l0cB/6cY1NcBBBO6FaCPLmC2GtwR+
 0edVBy7eED8FgPpONnmcg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

shacky schrieb:
> Hi.
> I'm using the 2.6.18 kernel (and I cannot upgrade it), but I need the
> "k8temp" module which is available only from the 2.6.21 version.
> Is there a way to use this module on my 2.6.18?

What is your problem that you cannot upgrade your kernel?

Backporting the k8temp is propably more difficult as installing
a newer kernel. Have a look at:
http://lists.debian.org/debian-amd64/2007/03/msg00005.html

Regards,
-- 
Clemens Koller
__________________________________
R&D Imaging Devices
Anagramm GmbH
Rupert-Mayer-Straße 45/1
Linhof Werksgelände
D-81379 München
Tel.089-741518-50
Fax 089-741518-19
http://www.anagramm-technology.com
