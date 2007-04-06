Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXDFVYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXDFVYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933094AbXDFVYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:24:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62721 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbXDFVYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:24:53 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: need help
To: vjn <vjn.raj@gmail.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 06 Apr 2007 23:24:41 +0200
References: <86Xi2-6La-421@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HZvvF-0001Z8-Lv@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19+3rxgiZ0U5QR3n8cD9M9Xf49WVWvD1K0wCyi
 FnuzvO2eEXyrjEqmioW3Axv7udi4LJURxm1S9NOsMFjwhy/SYd
 AGUK90u5uSKPWKDVIWGyw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vjn <vjn.raj@gmail.com> wrote:

> in my project i want to code the kernel such that when i plugged my usb it
> should ask for password and check it in the kernel space . can anyone help
> me

No, since the kernel has no way to ask for input. Imagine a two-seated
machine with two keyboards, mice and monitors, one terminal at each serial
port, three users logging in using XDM and one disconnected screen session
on tty6. Who's going to be asked? And in case of X11 or XDM: How should the
kernel authenticate to the user's screen?
-- 
A beggar walked up to a well-dressed woman shopping on Rodeo
Drive and said, "I haven't eaten anything for days."
She looked at him and said, "God, I wish I had your willpower."
Friﬂ, Spammer: O5YrJ-q@gshdlY.7eggert.dyndns.org
