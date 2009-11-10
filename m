Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZKJJtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZKJJtp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZKJJtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:49:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:54169 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbZKJJto convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:49:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jvhGiDWENPjFGAgtFexcwn5RGK5Fd27DyvC++v0fVGoItAtBqVs3ZH9auwlpuFG/5t
         bl0ASb+E2ALApC1q/PGkqT9DAhpE2v5IuPp9dLXVJgbc2MtmyvS/LK2p4QMs6mUFBa9b
         46aBFcumgO4/jbQBoNmd4zk6ZYA5nDSvSF/UI=
MIME-Version: 1.0
In-Reply-To: <b637ec0b0911092348x29453bco7f7ca94f3772601@mail.gmail.com>
References: <3642a3130911090908i55d6e1f2y6d9a5106d9febfc6@mail.gmail.com>
	 <20091109175728.4eec67b9@lxorguk.ukuu.org.uk>
	 <3642a3130911092236p11ef0502se12788800c8d2084@mail.gmail.com>
	 <3642a3130911092304x5c8fe8ddme1df39e6981cfe0a@mail.gmail.com>
	 <b637ec0b0911092348x29453bco7f7ca94f3772601@mail.gmail.com>
Date: Tue, 10 Nov 2009 10:49:48 +0100
Message-ID: <3642a3130911100149t7452a6f3k188e0fe972783521@mail.gmail.com>
Subject: Re: Kernel 2.6.29+ broke Cisco VPN Client
From: Mariusz Smykula <mariuszs@gmail.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 8:48 AM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
> Please have a look at:
>
> http://forum.tuxx-home.at/viewtopic.php?f=15&t=790#p5227
>
> There is a patch there that can be used to make CiscoVPN work with the
> latest stable kernels. For me it worked fine (over a wifi connection)
> until I lost interest as now I'm able to use vpnc, thanks to the
> people on the vpnc support forum.

I have no problem to compile and connect using CiscoVPN + 2.6.31, but
this is unstable solution. After some time (seconds or minutes) whole
computer is freezing dead.

vpnc is no option, because he lacks supports of certs auth.

I think something was changed in kernel Tun-Tap layer (or something
like that) that cause CIscoVPN problem.


-- 
Mariusz Smykuła
