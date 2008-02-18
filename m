Return-Path: <linux-kernel-owner+w=401wt.eu-S1759937AbYBRUoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759937AbYBRUoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbYBRUoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:44:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYBRUo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:44:29 -0500
Message-ID: <47B9EDF1.5050404@zytor.com>
Date: Mon, 18 Feb 2008 12:43:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dtor_core@ameritech.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: use explicit timing delay for pit accesses in kernel
 and pcspkr driver
References: <6gr00g$g7qpu0@smtp01.lnh.mail.rcn.net> <47B9ECE0.70000@keyaccess.nl>
In-Reply-To: <47B9ECE0.70000@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> Now with respect to the original pre port 80 "jmp $+2" I/O delay (which 
> the Pentium obsoleted) I suppose it'll probably be okay even without 
> fixing that specifically but do note such -- it's a vital part of the 
> problem.
> 

Sorry, that paragraph didn't parse for me.

	-hpa
