Return-Path: <linux-kernel-owner+w=401wt.eu-S1764599AbYCSVK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764599AbYCSVK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761780AbYCST7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:59:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48569 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761757AbYCST7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:59:05 -0400
Date: Tue, 18 Mar 2008 17:58:58 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Artem S. Tashkinov" <birdie@permonline.ru>
cc: linux-kernel@vger.kernel.org
Subject: Re: GIT commit description flag(s)
In-Reply-To: <47DC4104.1070109@permonline.ru>
Message-ID: <alpine.LNX.1.00.0803181757020.8851@fbirervta.pbzchgretzou.qr>
References: <47DC4104.1070109@permonline.ru>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 16 2008 02:35, Artem S. Tashkinov wrote:
> It would be nice if [kernel] git commits had a flag [a char] (or a combination 
> of) describing their main purpose which could be the following:
>
> bug Fix [F]
> Speed up/Performance [S]
> Revert [R]
> New functionality [N]

Usually you already give the type implicitly in the commit:

dfd347f... HID: fix comment in hid_input_report()
fa331ff... [S390] sclp_vt220: speed up console output for interactive work
d9452e9... [NETPOLL]: Revert two bogus cleanups that broke netconsole.
8727e28... m68k{,nommu}: Wire up new timerfd syscalls
b863ceb... [NET]: Add macvlan driver

So all is well.
