Return-Path: <linux-kernel-owner+w=401wt.eu-S1760048AbYDBTsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048AbYDBTsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbYDBTsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:48:09 -0400
Received: from c60.cesmail.net ([216.154.195.49]:62281 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048AbYDBTsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:48:08 -0400
Subject: Re: New IWL4935 driver for Intel Wireless Cards does not support
	WPA2 wireless network with PEAP - MSCHAPV2
From: Pavel Roskin <proski@gnu.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Luca Venturini <lucventurini@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
In-Reply-To: <20080402122440.GA24239@csclub.uwaterloo.ca>
References: <47F1F4F4.2080502@gmail.com>
	 <20080401164419.GA3530@tuxdriver.com>
	 <5d75f4610804011306y55352e73sb5223a294b66f2cf@mail.gmail.com>
	 <47F2A2F0.4060908@gmail.com>
	 <20080401205435.iov001h7gxs0o8sc@webmail.spamcop.net>
	 <20080402122440.GA24239@csclub.uwaterloo.ca>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 15:48:05 -0400
Message-Id: <1207165685.7840.5.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-02 at 08:24 -0400, Lennart Sorensen wrote:

> Strangely I find with the 2.6.24 kernel currently in Debian, the intel
> wireless seemed to work great with WPA2 (at least on a 4965).  Maybe
> that was 2.6.24.2 or 2.6.24.3 or something.  It was a couple of weeks
> ago now.  I haven't heard of the 4935 before.

Since nobody has mentioned that, it's possible to compile the latest
wireless drivers for the current kernel (starting with 2.6.18) thanks to
the compat-wireless package:

http://linuxwireless.org/en/users/Download

That should be of great help for those looking to use the latest
wireless drivers without having to recompile the currently used kernel.

-- 
Regards,
Pavel Roskin
