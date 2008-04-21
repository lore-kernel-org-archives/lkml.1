Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYDULlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYDULlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755476AbYDULlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:41:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46554 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbYDULlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:41:05 -0400
Message-ID: <480C7D4C.1070502@firstfloor.org>
Date: Mon, 21 Apr 2008 13:41:00 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, menage@google.com,
       xemul@openvz.org, shiwh@cn.fujitsu.com, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
References: <20080420072053.6bcb7884.akpm@linux-foundation.org> <Pine.LNX.4.64.0804210004470.1630@blonde.site> <20080421093059.57a61bc3.kamezawa.hiroyu@jp.fujitsu.com> <20080420232427.1b399104.akpm@linux-foundation.org> <480C347C.6060702@linux.vnet.ibm.com> <20080421064725.GA32214@balbir.in.ibm.com> <Pine.LNX.4.64.0804211158001.10521@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0804211158001.10521@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 21 Apr 2008, Balbir Singh wrote:
> I've added Andi to the Cc's, I don't want to sneak away something
> he's expecting there.  If 2.6.25 had gone out with a convention that
> controller infrastructure gets compiled in, but has then to be enabled
> at boottime or runtime, okay; 

That is what I have been expecting yes.

If later the slow down is fixed it can be also enabled by default too.

-Andi
