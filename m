Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbYJNVuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbYJNVuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYJNVt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:49:59 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:16316 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYJNVt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:49:58 -0400
X-Greylist: delayed 673 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2008 17:49:58 EDT
Date: Tue, 14 Oct 2008 16:38:20 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [REVERT Request] VT Breakage
Message-ID: <20081014213820.GA1312840@hiwaay.net>
References: <bmPNn-6ta-11@gated-at.bofh.it> <bmVzl-5F8-13@gated-at.bofh.it> <bmW2j-68c-3@gated-at.bofh.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F4DBA3.4060907@zytor.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, H. Peter Anvin <hpa@zytor.com> said:
>VT220 was monochrome, too.  You needed to go to the VT241 before you got 
>color in the DEC terminal range (and even it didn't support color text 
>via the SGR sequence (CSI m), according to the manual -- even the VT510 
>manual doesn't document colored text via SGR.)

The VT510 is also monochrome (I'm sitting here typing on one).
