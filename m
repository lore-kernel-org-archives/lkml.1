Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbYDBMYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbYDBMYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYDBMYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:24:42 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60720 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753470AbYDBMYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:24:40 -0400
Date: Wed, 2 Apr 2008 08:24:40 -0400
To: Pavel Roskin <proski@gnu.org>
Cc: Luca Venturini <lucventurini@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: New IWL4935 driver for Intel Wireless Cards does not support WPA2 wireless network with PEAP - MSCHAPV2
Message-ID: <20080402122440.GA24239@csclub.uwaterloo.ca>
References: <47F1F4F4.2080502@gmail.com> <20080401164419.GA3530@tuxdriver.com> <5d75f4610804011306y55352e73sb5223a294b66f2cf@mail.gmail.com> <47F2A2F0.4060908@gmail.com> <20080401205435.iov001h7gxs0o8sc@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401205435.iov001h7gxs0o8sc@webmail.spamcop.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2008 at 08:54:35PM -0400, Pavel Roskin wrote:
> 2.6.25.1 will be out after the first bug is fixed in Linux 2.6.25.  I  
> cannot promise you that any such bug would exist.  Actually, I hope  
> that there will be no reason for 2.6.25.1 release.
> 
> In any case, putting pressure on wireless developers is not  
> appreciated.  Maybe you should learn how to compile Linux kernels.  Or  
> maybe you should talk to Ubuntu release engineers and ask them not to  
> wait for 2.6.25.1 (provided that your implication is correct and they  
> would wait).

Or perhaps Ubuntu could learn from Debian and do releases when the
software is in a good state rather than at specific predetermined
release dates.  Or fix the bugs themselves and contribute them upstream.

Strangely I find with the 2.6.24 kernel currently in Debian, the intel
wireless seemed to work great with WPA2 (at least on a 4965).  Maybe
that was 2.6.24.2 or 2.6.24.3 or something.  It was a couple of weeks
ago now.  I haven't heard of the 4935 before.

-- 
Len Sorensen
