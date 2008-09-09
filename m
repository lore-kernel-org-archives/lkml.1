Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbYIIXsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbYIIXsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYIIXsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:48:25 -0400
Received: from gw.goop.org ([64.81.55.164]:48159 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbYIIXsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:48:25 -0400
Message-ID: <48C70B46.5030309@goop.org>
Date: Tue, 09 Sep 2008 16:48:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keiichiro Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: ifdef Quicklists in /proc/meminfo
References: <Pine.LNX.4.64.0809081351240.4983@blonde.site> <20080909084241.41A0.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48C5BBEC.5060405@zytor.com>
In-Reply-To: <48C5BBEC.5060405@zytor.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> x86 *does* use quicklists, at least with PAE.

No, not for a while now.

    J
