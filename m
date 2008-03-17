Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbYCQBbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbYCQBbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 21:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYCQBbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 21:31:01 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:60488 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751594AbYCQBbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 21:31:01 -0400
Message-ID: <47DDC9EC.4060208@davidnewall.com>
Date: Mon, 17 Mar 2008 12:01:24 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Willy Tarreau <w@1wt.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <200803151500.05993.phillips@phunq.net> <20080315230558.12e9c96c@the-village.bc.nu> <200803161457.04580.phillips@phunq.net>
In-Reply-To: <200803161457.04580.phillips@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> The UPS provides a guarantee of commit to stable storage.  No amount of
> FUD will change that.

What about system crashes?  They guarantee that data will be lost.  I
know opinions are divided on the subject of crashes: You say Linux
doesn't; everybody else says it does.  I side with experience.  (It does.)
