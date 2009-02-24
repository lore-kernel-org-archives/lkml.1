Return-Path: <linux-kernel-owner+w=401wt.eu-S1759108AbZBXRJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbZBXRJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 12:09:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZBXRJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 12:09:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37036 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZBXRJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 12:09:32 -0500
Date: Tue, 24 Feb 2009 18:09:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, heukelum@fastmail.fm
Subject: Re: [patch 0/6] x86-tip cleanup series
Message-ID: <20090224170920.GB14553@elte.hu>
References: <20090223195656.512422509@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223195656.512422509@openvz.org>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Hi,
> 
> here is a small series of trivial cleanups.
> 
> I'm not sure if it's a good idea to bring GLOBALs
> into entry_64.S so please check if it really
> become forming into better shape
> (patch titled x86: head_64.S - use GLOBAL macro)

they look good - i've applied them to tip:x86/asm, thanks 
Cyrill!

	Ingo
