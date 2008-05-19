Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbYESMaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYESMaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbYESMaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:30:05 -0400
Received: from main.gmane.org ([80.91.229.2]:47524 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbYESMaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:30:03 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [PATCH] Re: [PATCH] drivers/net: remove network drivers' last few uses of IRQF_SAMPLE_RANDOM
Date: Mon, 19 May 2008 14:29:38 +0200
Message-ID: <m3r6bya34d.fsf@ursa.amorsen.dk>
References: <87abirytxj.fsf@basil.nowhere.org> <20080516105635.6cb1f505@core> <482D5FC5.2070103@firstfloor.org> <20080516121239.GA9627@gondor.apana.org.au> <482DB568.1040704@firstfloor.org> <20080517010136.GA15102@gondor.apana.org.au> <482EBAA8.3040506@firstfloor.org> <a24804730805171254i2a37da61mb47280db7b330ed5@mail.gmail.com> <20080517130535.02d45372@infradead.org> <4830014F.9040800@firstfloor.org> <20080518112657.GK16496@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: hd5b9080a.c45-01-12.sta.perspektivbredband.net
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:8uBLpo4LTU29SEJpPj/8l7mRHj0=
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> also, mixing in whatever randomness it can get from the mouse during
> the install is also a Really Good Idea.)

I suspect that most server installations are completely automated. No
input device activity at all.


/Benny


