Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbXFRBk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbXFRBk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 21:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbXFRBks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 21:40:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37564 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbXFRBkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 21:40:47 -0400
Subject: Re: AT_ENTROPY1 and AT_ENTROPY2 values for include/linux/auxvec.h
From: Arjan van de Ven <arjan@infradead.org>
To: Alexander Gabert <pappy@gentoo.org>
Cc: libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
       hardened@gentoo.org
In-Reply-To: <4675DFA8.6060703@gentoo.org>
References: <4675C678.3080807@gentoo.org>
	 <1182128803.22999.9.camel@laptopd505.fenrus.org>
	 <4675DFA8.6060703@gentoo.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 17 Jun 2007 18:38:00 -0700
Message-Id: <1182130680.22999.13.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hence the config option for the kernel- it's philosophy at Gentoo to 
> make choices available to users how they want their systems to behave, 
> even on the expense of added complexity and need to "understand" how 
> things work in the first place.

While I am not opposed to choice, I am opposed to having too finegrained
kernel config options. In your view, every single kernel patch would be
a config option... I much rather have config options for "important" big
changes, not for something this small. Another argument is that this
kind of userspace interface is better off being always there or never;
making this variable serves no-one.



-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

