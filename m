Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZFXVmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZFXVmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZFXVmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:42:00 -0400
Received: from fmailhost02.isp.att.net ([207.115.11.52]:42089 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZFXVl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:41:59 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A429DAA.3010303@lwfinger.net>
Date: Wed, 24 Jun 2009 16:42:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Gary Hade <garyhade@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
References: <1245845787.3093.3.camel@localhost.localdomain>	 <1245859068.3216.5.camel@localhost.localdomain>	 <20090624161306.GC7239@us.ibm.com>	 <1245861219.3216.15.camel@localhost.localdomain>	 <20090624094411.08fc66e6@jbarnes-g45>	 <20090624175513.GE7239@us.ibm.com>	 <20090624112849.55b38fff@jbarnes-g45>	 <alpine.LFD.2.00.0906242043230.2767@localhost.localdomain>	 <20090624194839.GG7239@us.ibm.com> <4A4286F8.9020501@lwfinger.net> <86802c440906241432l6d601f76sf2a413d6e19079e6@mail.gmail.com>
In-Reply-To: <86802c440906241432l6d601f76sf2a413d6e19079e6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> please fix the whole boot log with debug.
> 
> need to make sure how many HT chain in your system.

Do you mean the output of dmesg? I'm not sure what you mean by "debug".

Larry
