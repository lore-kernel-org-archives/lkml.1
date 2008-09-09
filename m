Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYIIXyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYIIXyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYIIXyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:54:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60124 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYIIXyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:54:05 -0400
Message-ID: <48C70BCC.8090707@zytor.com>
Date: Tue, 09 Sep 2008 16:50:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keiichiro Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ifdef Quicklists in /proc/meminfo
References: <Pine.LNX.4.64.0809081351240.4983@blonde.site> <20080909084241.41A0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48C5BBEC.5060405@zytor.com> <48C70B46.5030309@goop.org>
In-Reply-To: <48C70B46.5030309@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> x86 *does* use quicklists, at least with PAE.
> 
> No, not for a while now.

Sorry, stale cache...

	-hpa
