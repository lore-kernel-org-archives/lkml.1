Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZG0FaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZG0FaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 01:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZG0FaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 01:30:00 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:54819 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbZG0F37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 01:29:59 -0400
Message-ID: <4A6D3C0F.3050605@pardus.org.tr>
Date: Mon, 27 Jul 2009 08:33:03 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       jouni susiluoto <jouni.susiluoto@helsinki.fi>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [Bug #13700] usb error flood in dmesg, makes kde use plenty of
 cpu - bisected
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.ejE.GIObKB@chimera>
In-Reply-To: <3zAHs5O6maO.A.ejE.GIObKB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote On 26-07-2009 23:28:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13700
> Subject		: usb error flood in dmesg, makes kde use plenty of cpu - bisected
> Submitter	: jouni susiluoto <jouni.susiluoto@helsinki.fi>
> Date		: 2009-07-03 21:13 (24 days old)
>   
This is also an issue for 2.6.30 so it should have been listed in the
other 2.6.29->2.6.30 list I think.
