Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbXKOS11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbXKOS11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 13:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759580AbXKOS1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 13:27:16 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52292 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759529AbXKOS1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 13:27:15 -0500
Date: Thu, 15 Nov 2007 10:27:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Gautham R Shenoy <ego@in.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 0/3] Refcount Based Cpu Hotplug V3
In-Reply-To: <20071115134924.GA15282@in.ibm.com>
Message-ID: <Pine.LNX.4.64.0711151026310.27721@schroedinger.engr.sgi.com>
References: <20071115134924.GA15282@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Good stuff! Better than the other locking schemes that I have seen go by.

