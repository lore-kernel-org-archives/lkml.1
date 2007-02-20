Return-Path: <linux-kernel-owner+w=401wt.eu-S1161094AbXBTXhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161094AbXBTXhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161079AbXBTXhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:37:12 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44665 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161094AbXBTXhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:37:09 -0500
Date: Tue, 20 Feb 2007 17:37:06 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sam Vilain <sam@vilain.net>
Cc: Paul Menage <menage@google.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Message-ID: <20070220233706.GD7888@sergelap.austin.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com> <45D0EC68.9090009@vilain.net> <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com> <m1wt2c4ttj.fsf@ebiederm.dsl.xmission.com> <6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com> <45DB6F07.8080409@vilain.net> <6599ad830702201419n2fe02661y58f09f7dc8d23d88@mail.gmail.com> <45DB7D05.2030800@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DB7D05.2030800@vilain.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sam Vilain (sam@vilain.net):
> Paul Menage wrote:

> We talked about naming a bit before, see
> http://lkml.org/lkml/2006/3/21/403 and possibly other threads.  So,
> anyway, feel free to flog this old dead horse and suggest different
> terms.  We've all had long enough to think about it since so maybe it's

Bah,

Paul, how about s/container/rug/, as in resource usage group?

At least you can be pretty sure that (a) rug won't conflict with any
other computer science therm, and (b) for that exact reason it should be
pretty memorable.

-serge
