Return-Path: <linux-kernel-owner+w=401wt.eu-S2992566AbXCGUwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992566AbXCGUwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992565AbXCGUw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:52:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.179]:56394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992570AbXCGUw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:52:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux v2.6.21-rc3
Date: Wed, 7 Mar 2007 21:52:26 +0100
User-Agent: KMail/1.9.6
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <1173263132.9349.47.camel@localhost.localdomain> <Pine.LNX.4.64.0703070735240.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703070735240.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703072152.26479.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:bf0b512fe2ff06b96d9695102898be39
X-Provags-ID2: V01U2FsdGVkX1/Fcr4SQ+jAUaQIAlO+VUvoy2BioGHqHZM73NC
 du07Rjlvk6pRnhnyEz/lUFIMqBh11pX9GmaIFsxDHch8Vy9Ifg
 0m4bgKL8CSf1who98maow==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2007 16:39:00 Linus Torvalds wrote:
> So did you hunt it down to a particular cases where it triggers?

IIRC, it crashed on boot in the powerpc iommu code when slab
debugging is enabled. Not sure if it was on Cell or on benh's
powerbook though.

	Arnd <><
