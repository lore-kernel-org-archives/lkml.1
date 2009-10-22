Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZJVWpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZJVWpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZJVWpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:45:00 -0400
Received: from dan.rpsys.net ([93.97.175.187]:54553 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbZJVWpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:45:00 -0400
Subject: Re: zaurus: cleanup sharpsl_pm.c
From: Richard Purdie <rpurdie@rpsys.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
In-Reply-To: <20091022174816.GC5325@elf.ucw.cz>
References: <20091006200339.GA1538@ucw.cz> <20091017163627.GB1423@ucw.cz>
	 <f17812d70910200859v6d18e81bs2760d8af1d8da5bf@mail.gmail.com>
	 <f17812d70910220705o9f4a0ddwa22157b59a519350@mail.gmail.com>
	 <20091022174816.GC5325@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 22 Oct 2009 23:40:52 +0100
Message-Id: <1256251252.23211.158.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 19:48 +0200, Pavel Machek wrote:
> Introduce separate set of battery limits for corgi. This fixes
> compilation, and the values probably should be subtly different, too.

Corgi and spitz share the same batteries and charging circuits, its just
connected differently. This is why they shared the tables you've just
duplicated...

Cheers,

Richard


-- 
Richard Purdie
Intel Open Source Technology Centre

