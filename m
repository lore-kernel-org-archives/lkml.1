Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYG1NMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYG1NMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYG1NMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:12:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:48093 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYG1NMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:12:31 -0400
Date: Mon, 28 Jul 2008 06:12:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: NETDEV WATCHDOG: wifi0: transmit timed out
Message-ID: <20080728061226.26ffae06@infradead.org>
In-Reply-To: <dd18b0c30807280010h34002232wb53b7a154d9853fc@mail.gmail.com>
References: <dd18b0c30807280010h34002232wb53b7a154d9853fc@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 00:10:46 -0700
"Justin Mattock" <justinmattock@gmail.com> wrote:

> I should'nt be posting this, due to
> having  tainted modules(madwifi), but

and fglrx

> I figured I might as well:(below)
> 
> [ 5000.986044] NETDEV WATCHDOG: wifi0: transmit timed out

and what's more... it's the the wifi that's b0rked.

sounds like you want to switch to ath5k or ath9k.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
