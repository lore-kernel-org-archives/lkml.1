Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbZIVOCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbZIVOCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZIVOCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:02:52 -0400
Received: from fifo99.com ([67.223.236.141]:55217 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756611AbZIVOCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:02:51 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Daniel Walker <dwalker@fifo99.com>
To: Raistlin <raistlin@linux.it>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <1253628061.20345.173.camel@Palantir>
References: <1253615424.20345.76.camel@Palantir>
	 <1253625878.6575.34.camel@desktop>  <1253628061.20345.173.camel@Palantir>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 07:02:55 -0700
Message-Id: <1253628175.6575.40.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 16:01 +0200, Raistlin wrote:
> On Tue, 2009-09-22 at 06:24 -0700, Daniel Walker wrote:
> > You've got some type of encoding corruption in your patch,
> > 
> Oops! Sorry about that... :(
> 
> > See the =20 , and =3D above.. I'm not sure exactly how that gets into
> > patches ;( We require utf8 encodings , some people can handle the stuff
> > above but most scripts and the patch command won't be able to. 
> >
> I see. Problem is that last time I sent a patch, I inlined it and it
> worked without any issue... It seems something has changed either in me
> or my MUA... Too bad. :-(
> 
> > I realize
> > this is an RFC , so the next time you submit this try to make it utf8 ..
> > 
> You're definitely right and, now that you pointed this out to me, I'm
> not able to produce a clean version, even if I set utf8 encoding...
> 
> So, I'm sorry, but, for now, the only thing I can do is attaching the
> patch, hoping it works. The next one will be stop using Evolution! :-/

Your using git already , why not use git-format-patch and
git-send-email ?

Daniel

