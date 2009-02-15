Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZBORVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZBORVT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 12:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZBORVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 12:21:07 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52275 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbZBORVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 12:21:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49984ED4.4000306@s5r6.in-berlin.de>
Date: Sun, 15 Feb 2009 18:20:20 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Junio C Hamano <junio@pobox.com>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ingo Oeser <ioe-lkml@rameria.de>, Peter Zijlstra <peterz@infradead.org>,
       L-K <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: git-send-email
References: <1234451714.10603.22.camel@laptop> <20090212192104.GD15809@csclub.uwaterloo.ca> <1234477025.10603.38.camel@laptop> <200902131034.05814.ioe-lkml@rameria.de> <20090213163923.GE15809@csclub.uwaterloo.ca> <7vtz6y6kjt.fsf@gitster.siamese.dyndns.org>
In-Reply-To: <7vtz6y6kjt.fsf@gitster.siamese.dyndns.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano wrote:
> Just like the kernel folks take regressions seriously to the point to say
> breaking one person's working setup is worse than fixing a known bug that
> affects many more people,

BTW, from the manual:

       --chain-reply-to, --no-chain-reply-to
           [...] Default is the value of the sendemail.chainreplyto
           configuration value; if that is unspecified, default to
           --chain-reply-to.

Everybody who isn't afraid of configuration files can implement his
preferred default easily.
-- 
Stefan Richter
-=====-==--= --=- -====
http://arcgraph.de/sr/
