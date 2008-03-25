Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYCYP51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYCYP51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 11:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbYCYP5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 11:57:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59744 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbYCYP5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 11:57:19 -0400
Date: Tue, 25 Mar 2008 16:57:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86 - relocate_kernel cleanup
Message-ID: <20080325155657.GD27174@elte.hu>
References: <20080322210005.117475478@gmail.com> <47E576B9.6090205@zytor.com> <47E577B9.1010403@zytor.com> <20080323111017.GA7612@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323111017.GA7612@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> You know, Peter, I'm a bit scared that these flags are in number of 
> files and could break others queued patches...

as long as your work against x86.git/latest you shouldnt be worried 
about any clashes.

	Ingo
