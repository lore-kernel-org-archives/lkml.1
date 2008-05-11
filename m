Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYEKRWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYEKRWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYEKRWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:22:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:14357 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYEKRWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:22:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=p8pkz55+H1ocJyjuUVVdL+7aUzuPd6Axuz7upgH13oGuBjAAZk/UcVOB+7+MyaK4NUtgHXbuqMhqj5kAaoe8EXTtp23R5pEhQWF01EeeRmqVROOyo2pmnQEOBnV1uud7JXeygcte77FtL4H+lzkdco0RlCSsxX44L3QfsAn63bM=
Message-ID: <2c0942db0805111022p5c977cdw75aaf10caed7ee7e@mail.gmail.com>
Date: Sun, 11 May 2008 10:22:42 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] kernel/sched*: optimize inlining
Cc: "Andreas Mohr" <andi@lisas.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080511125221.GF1645@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080511092132.GE1645@cs181133002.pp.htv.fi>
	 <20080511111820.GA3326@rhlx01.hs-esslingen.de>
	 <20080511125221.GF1645@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: acf432af4e68b468
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 5:52 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Sun, May 11, 2008 at 01:18:20PM +0200, Andreas Mohr wrote:
> If you didn't complain when "x86: add optimized inlining" got into
> Linus' tree you can't validly complain about my patch.

You would fail a course in logic. Please read up on "The fallacy of
division" (aka Fallacy of decomposition), and try your argument again.
