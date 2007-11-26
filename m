Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbXKZD5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbXKZD5n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 22:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbXKZD5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 22:57:34 -0500
Received: from ozlabs.org ([203.10.76.45]:46874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466AbXKZD5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 22:57:34 -0500
From: Jeremy Kerr <jk@ozlabs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH] Export force_sig_info
Date: Mon, 26 Nov 2007 14:56:51 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org
References: <1194845812.531937.269801315194.qpush@pokey> <20071122234141.087743fa.akpm@linux-foundation.org>
In-Reply-To: <20071122234141.087743fa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711261456.53683.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> Perhaps export it from within a powerpc-specific C file (along with
> suitable comment) to prevent people from generally relying upon the
> export?

Even better, I'll export it from a Cell-specific C file. I'll follow 
this up in my own spufs series for .25.

Cheers,


Jeremy




