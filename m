Return-Path: <linux-kernel-owner+w=401wt.eu-S1758424AbYFDOXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424AbYFDOXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYFDOXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:23:16 -0400
Received: from smtpout01s1.x-echo.com ([193.252.149.37]:54640 "EHLO
	smtpout01s1.x-echo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbYFDOXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:23:16 -0400
From: Lkm <lkm@lea-linux.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: PROBLEM: Hardware clock instable
Date: Wed, 4 Jun 2008 16:22:49 +0200
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <200806041402.39515.lkm@lea-linux.com> <200806041517.43347.lkm@lea-linux.com> <e2e108260806040640k3ffb9712j443c2da37feb394c@mail.gmail.com>
In-Reply-To: <e2e108260806040640k3ffb9712j443c2da37feb394c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806041622.49593.lkm@lea-linux.com>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wednesday 04 June 2008 15:40:49 Bart Van AsscI de, vous avez écrit :
> On Wed, Jun 4, 2008 at 3:17 PM, Lkm <lkm@lea-linux.com> wrote:
> > Ntpd logs:
>
> ...
>
> >  2 Jun 13:42:20 ntpd[2299]: time reset -109.498922 s
>
> ...
>
> The reason I asked for the ntpd logs is that I'm still not sure
> whether there is a hardware problem.

In fact i'm wondering too .... But we have so many server with the same 
problem...

> How long was the ntpd process 
> running when the above line was logged ?

I have rebooted the server on Mon Jun  2 13:37 (show in last command) for 
testing clock and clocksource boot argument.
If i look forward in the log:
26 Feb 11:25:12 ntpd[2422]: time reset -0.492486 s
I Don't know if we have rebooted the server this day..


> And can you also post the 
> output of ntpq -pn ?
>
ntpq -pn
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
+192.168.0.150   195.220.194.193  3 u  531 1024  377    1.398    0.606   0.402
*192.168.0.151   194.2.0.28       3 u  399 1024  377    0.554    0.426   0.172

> Bart.


