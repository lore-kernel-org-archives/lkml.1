Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbZEKRR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbZEKRR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 13:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbZEKRRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 13:17:19 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:40691 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZEKRRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 13:17:18 -0400
MIME-Version: 1.0
In-Reply-To: <m1k54nfv9h.fsf@fess.ebiederm.org>
References: <20090509143742.GA27663@kroah.com> <20090509161923.GA942@suse.de> 
	<20090509223454.4642753d.akpm@linux-foundation.org> <20090510152005.GA9461@suse.de> 
	<1241980263.9562.380.camel@laptop> <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk> 
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com> 
	<20090510170016.1e3a4d97@infradead.org> <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> 
	<m1k54nfv9h.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 19:16:58 +0200
Message-ID: <ac3eb2510905111016u1a79defctff3578688ee36f00@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 18:40, Eric W. Biederman <ebiederm@xmission.com> wrote:
> The goal for kernel compile options is that they do not affect the
> kernels behavior.  The behavior in devmtmpfs clearly does not match
> that rule.  The kernel acts very different with it compiled in
> and with it not compiled in. So that section of the code deserves.

It's the same as with any other option, like the ones that enable
dynamic minors.

Kay
