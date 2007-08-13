Return-Path: <linux-kernel-owner+w=401wt.eu-S948036AbXHMPIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948036AbXHMPIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S945603AbXHMMvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 08:51:05 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:59891 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935974AbXHMMvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 08:51:00 -0400
Date: Mon, 13 Aug 2007 08:50:56 -0400
To: <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 4 of 5 ] /drivers/char/rio ioremap balancing/ returncode check
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070813125056.E10A0DA832@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 06:42:35 -0400 Alan Cox 
<alan@lxorguk.ukuu.org.uk> wrote:

>Your mail client has wrapped the patches. Please resend without 
>wrapping

Much as I'd love to blame my mail client for this one...

Patch 4 of the 5 I sent was the only one with wrapping, and that 
wrapping existed in abundance in /drivers/char/rio/rio_linux.c file 
long before I got there.  Several lines in that file exceed 100 
columns, I think the "winner" was around 142.

I think tackling all the wordwrap issues would belong in a 
different patch as I'm just trying to clean up ioremap usage.  And, 
yes, I contributed *one more* wordwrap issue to the file, but when 
in Rome...

---------------------------------------
Scott Thompson / postfail@hushmail.com
---------------------------------------



