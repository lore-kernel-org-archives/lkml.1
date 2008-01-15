Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYAOBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYAOBWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 20:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbYAOBWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 20:22:12 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59014 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYAOBWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 20:22:11 -0500
Date: Tue, 15 Jan 2008 10:20:54 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC][PATCH 3/5] add /dev/mem_notify device
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080114170804.b5961aea.randy.dunlap@oracle.com>
References: <20080115100029.1178.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080114170804.b5961aea.randy.dunlap@oracle.com>
Message-Id: <20080115101803.1183.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi randy

> Hi,
> 
> 1/ I don't see the file below listed in the diffstat above...

Agghh...
sorry, it is mistake.
I repost soon. 

thanks.


> 2/ Where is the userspace interface information for the syscall?

No.
userspace interface is only poll(2).



