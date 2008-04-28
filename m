Return-Path: <linux-kernel-owner+w=401wt.eu-S1764310AbYD1AxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764310AbYD1AxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYD1AxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:53:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55630 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYD1AxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:53:14 -0400
Message-ID: <48151FD3.4040409@zytor.com>
Date: Sun, 27 Apr 2008 17:52:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Rik van Riel <riel@redhat.com>, David Miller <davem@davemloft.net>,
       mingo@elte.hu, James.Bottomley@HansenPartnership.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <20080427214837.GA11631@elte.hu> <1209333959.3801.67.camel@localhost.localdomain> <20080427231809.GA13848@elte.hu> <20080427.163106.181887129.davem@davemloft.net> <20080427203127.3c7d0e58@bree.surriel.com> <20080428004507.GY5882@ZenIV.linux.org.uk>
In-Reply-To: <20080428004507.GY5882@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> are you going to tell me that this had been reviewed?  Note these
> ntohs() applied to 8bit values in there.  Two signed-off-by, including
> Greg "two s-o-b are enough to guarantee review"...

I thought it was well established that Signed-off-by was about copyright 
and patch flow, *nothing else*.

	-hpa
