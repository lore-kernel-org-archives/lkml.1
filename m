Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZBPVBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZBPVBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbZBPVBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:01:33 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:33412 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZBPVBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:01:32 -0500
Date: Mon, 16 Feb 2009 12:58:18 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Junio C Hamano <junio@pobox.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ingo Oeser <ioe-lkml@rameria.de>, Peter Zijlstra <peterz@infradead.org>,
       L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
Message-ID: <20090216205818.GA12345@ca-server1.us.oracle.com>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Junio C Hamano <junio@pobox.com>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Ingo Oeser <ioe-lkml@rameria.de>,
	Peter Zijlstra <peterz@infradead.org>,
	L-K <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <1234451714.10603.22.camel@laptop> <20090212192104.GD15809@csclub.uwaterloo.ca> <1234477025.10603.38.camel@laptop> <200902131034.05814.ioe-lkml@rameria.de> <20090213163923.GE15809@csclub.uwaterloo.ca> <7vtz6y6kjt.fsf@gitster.siamese.dyndns.org> <49984ED4.4000306@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49984ED4.4000306@s5r6.in-berlin.de>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4999D3DF.006D:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 06:20:20PM +0100, Stefan Richter wrote:
> Junio C Hamano wrote:
> > Just like the kernel folks take regressions seriously to the point to say
> > breaking one person's working setup is worse than fixing a known bug that
> > affects many more people,
> 
> BTW, from the manual:
> 
>        --chain-reply-to, --no-chain-reply-to
>            [...] Default is the value of the sendemail.chainreplyto
>            configuration value; if that is unspecified, default to
>            --chain-reply-to.
> 
> Everybody who isn't afraid of configuration files can implement his
> preferred default easily.

	Actually, the big trouble is when you log into a machine that
doesn't have your config and don't realize it.  I have the configuration
option set, and I still put --no-chain-reply-to on every command line,
because I've been bitten before.
	The problem with the default of --chain-reply-to is that many
folks consider the resulting email chain rude and stupid.  So the
consequence of not putting it on every command line is occasionally
looking like an idiot.

Joel


-- 

	f/8 and be there.

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
