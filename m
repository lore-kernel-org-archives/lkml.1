Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0BWNQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 08:16:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60396 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab0BWNQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 08:16:53 -0500
X-Authority-Analysis: v=1.0 c=1 a=pi97quWTHqIA:10 a=VwQbUJbxAAAA:8 a=_q2IS3Dq3vcCj2ohVVIA:9 a=FE_Hr-30pBtF0tkxGt5MXDTCjY4A:4 a=U62fhAwekXMA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: ketchup was Re: [kernel.org users] XZ Migration discussion
From: Steven Rostedt <rostedt@goodmis.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100222185928.GA1572@ucw.cz>
References: <4B744E13.8040004@kernel.org>
	 <20100212150137.648dca7c@hyperion.delvare>
	 <1265988318.24271.30.camel@gandalf.stny.rr.com>
	 <20100216153905.GA1541@ucw.cz>
	 <1266337061.24271.138.camel@gandalf.stny.rr.com>
	 <20100216162745.GA1660@ucw.cz> <20100221135341.GC1307@ucw.cz>
	 <20100222185928.GA1572@ucw.cz>
Content-Type: text/plain
Date: Tue, 23 Feb 2010 08:14:33 -0500
Message-Id: <1266930873.19540.2.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 19:59 +0100, Pavel Machek wrote:
> On Sun 2010-02-21 14:53:41, Pavel Machek wrote:
> > On Tue 2010-02-16 17:27:45, Pavel Machek wrote:
> > > Add --only-dl option -- when you want to cache the needed patches but
> > > not apply anything yet.
> > 
> > Actually, you'll probably get a better patch if you relace 'only-dl'
> > with just 'dl'. Mistaking --only-dl and --dl-only is just too easy.
> 
> This should work; save time&bandwidth by using incremental patches
> between -rcX.
> 
> Is there testsuite for ketchup? It would be useful at this point...

I don't have one, but that would be helpful.

Would you like to take over maintaining ketchup? I took it over because
Matt did not want it anymore and I was the last to send him patches.

I've been quite busy working on Ftrace, trace-cmd and kconfig stuff,
that I'm willing to hand this over to you, if you want it. My last
release of ketchup is my git tree on kernel.org.

-- Steve


