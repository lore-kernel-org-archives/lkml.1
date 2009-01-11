Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZAKPTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZAKPTn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:19:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZAKPTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:19:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZAKPTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:19:34 -0500
Date: Sun, 11 Jan 2009 16:19:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dieter Ries <clip2@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
Message-ID: <20090111151924.GA5722@elte.hu>
References: <496A085E.8020604@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496A085E.8020604@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dieter Ries <clip2@gmx.de> wrote:

> Hi,
> 
> I just pulled 2.6.29-rc1, ran oldconfig with defaults and built it.
> When I try to boot it, that kind of works until init should start. Then
> nothing happens. I tried with init=/bin/bash, which sometimes works, and
> sometimes gets me a bash without the prompt flashing.
> 
> I captured the output with netconsole, but I cannot see a problem there.
> It is attached.
> 
> My config is also attached.
> 
> The machine:
> 
> Lenovo Thinkpad T60
> Core2Duo 2GHz
> 
> Gentoo 64bit
> 
> Everything worked fine with 83bc66f, which was my last pull.
> 
> What else should I provide for debugging that?

hm, there's no 83bc66f in Linus's tree.

	Ingo
