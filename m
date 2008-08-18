Return-Path: <linux-kernel-owner+w=401wt.eu-S1760285AbYHRTYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760285AbYHRTYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbYHRTYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:24:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49163 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883AbYHRTYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:24:05 -0400
Message-ID: <48A9CADB.4040703@zytor.com>
Date: Mon, 18 Aug 2008 12:17:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joro@8bytes.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 53/60] x86: fix setup code crashes on my old 486 box
References: <20080818183230.966310219@mini.kroah.org> <20080818184530.GB29394@suse.de>
In-Reply-To: <20080818184530.GB29394@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

No objection here.

Acked-by: H. Peter Anvin <hpa@zytor.com>
