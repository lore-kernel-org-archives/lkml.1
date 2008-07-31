Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYGaPTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYGaPTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbYGaPTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:19:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbYGaPS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:18:59 -0400
Message-ID: <4891D3B2.2000108@redhat.com>
Date: Thu, 31 Jul 2008 10:01:06 -0500
From: Clark Williams <williams@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Sebastien Dugue <sebastien.dugue@bull.net>
CC: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@gmail.com>,
       Chirag Jog <chirag@linux.vnet.ibm.com>,
       J?rgen Mell <j.mell@t-online.de>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Josh Triplett <josht@linux.vnet.ibm.com>,
       "Timothy R. Chavez" <tim.chavez@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix Bug messages
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>	<alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de>	<alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>	<200807301101.32417.j.mell@t-online.de>	<20080730171842.GB3420@linux.vnet.ibm.com>	<20080731100023.0221ec2b@bull.net>	<520f0cf10807310313q45599221q3db1b6fd7e7c722f@mail.gmail.com>	<20080731132336.362bd487@bull.net>	<520f0cf10807310649l1083e29bmf0f704e13dee96c@mail.gmail.com>	<1217512907.8157.91.camel@twins> <20080731163515.4a992060@bull.net>
In-Reply-To: <20080731163515.4a992060@bull.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sebastien Dugue wrote:
>   This does indeed seem to fix the problem, no more BUGs appearing
> on the console with 2.6.26-rt1 now.
> 
>   Thanks,
> 
>   Sebastien.

Sebastien,

Would you send me your config? I'm running -rt1 on my laptop and am not seeing any of
the messages you listed earlier. It's bound to be that I turned off something that
you're using, so I'd like to see what that is.

Thank,
Clark
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iEYEARECAAYFAkiR07IACgkQHyuj/+TTEp2LgACfTK3sNyABEtR+BDc29L3DdP/c
KKsAoM0RvuG4EHLyfHJUnfERhXbWuZY4
=1eZ6
-----END PGP SIGNATURE-----
