Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYEYNdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYEYNdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYEYNdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:33:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54743 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751976AbYEYNdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:33:04 -0400
Date: Sun, 25 May 2008 14:16:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Message-ID: <20080525141638.65111d64@core>
In-Reply-To: <200805251414.04509.mb@bu3sch.de>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	<200805251149.41059.mb@bu3sch.de>
	<9995307A-E602-4A30-8900-6AEDDF7D1D8F@holtmann.org>
	<200805251414.04509.mb@bu3sch.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What if I want 2 or 3 different firmware versions installed at once?
> I'll have to play dirty tricks with the filenames then and put several
> unrelated firmware versions into one directory. That's going to be a mess.

You add the desired feature to udev, or use symlinks. Hardly a "mess".

Alan
