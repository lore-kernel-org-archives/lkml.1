Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbYDGV7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbYDGV7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYDGV64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:58:56 -0400
Received: from twin.jikos.cz ([213.151.79.26]:51084 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbYDGV64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:58:56 -0400
Date: Mon, 7 Apr 2008 23:58:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
cc: linux-kernel@vger.kernel.org
Subject: Re: keyboard disconnects with kernel 2.6.24-r4
In-Reply-To: <200804072045.m37KjFEX016950@indigo.cs.bgu.ac.il>
Message-ID: <Pine.LNX.4.64.0804072357280.26562@twin.jikos.cz>
References: <200804072045.m37KjFEX016950@indigo.cs.bgu.ac.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Apr 2008, eial@cs.bgu.ac.il wrote:

> hello, I own a DV9000z, running gentoo and kernel 2.6.24-r3 on it, I'm 
> not using r4 because while working with the computer, after a while, my 
> keyboard disconnects. trying to shutdown the computer causes in system 
> freeze. this do not happens in r3, 

What are "r3" and "r4"? Do you mean -rc3 and -rc4? If so, please try to 
reproduce with recent kernel first (we are now past 2.6.25-rc8), and 
report back in case the problem still persists.

-- 
Jiri Kosina
SUSE Labs

