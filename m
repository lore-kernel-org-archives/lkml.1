Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYERK1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYERK1m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 06:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbYERK1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 06:27:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43052 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYERK1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 06:27:34 -0400
Message-ID: <48300493.9050800@firstfloor.org>
Date: Sun, 18 May 2008 12:27:31 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc* - CONFIG_FRAME_WARN help text clarification...
References: <74983.1211030892@turing-police.cc.vt.edu>
In-Reply-To: <74983.1211030892@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> I hit this during a 'make oldconfig', and had to ponder and dig through the
> Makefiles to see if pre-4.4 should set it to 0, or not.
> 
> Make it clear to people who hit this in a 'make oldconfig' that it's safe to
> set it so that whenever their box finally *does* get gcc 4.4, it will be used.

I don't think "doesn't work" is the same as "safe".

Also submit patches always with diff -u

-Andi

