Return-Path: <linux-kernel-owner+w=401wt.eu-S937576AbXHPA6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937576AbXHPA6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763985AbXHPA6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:58:37 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:48331 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbXHPA6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:58:36 -0400
Message-ID: <46C3A04E.7030205@gmail.com>
Date: Thu, 16 Aug 2007 02:54:38 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: RFC: do get_rtc_time() correctly
References: <46C35284.1080003@reed.com> <20070816005151.56176a04@the-village.bc.nu> <46C399C1.9000502@reed.com>
In-Reply-To: <46C399C1.9000502@reed.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2007 02:26 AM, David P. Reed wrote:

> My mention of NMI (which by definition can't be masked) is because NMI

Well, not by the CPU it can't, but on a PC, masking NMIs is a simple matter 
of setting bit 7 of I/O port 0x70 to 1 (it seems the kernel does not provide 
an interface for it though?).

Rene.

