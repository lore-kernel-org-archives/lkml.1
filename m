Return-Path: <linux-kernel-owner+w=401wt.eu-S1752935AbYLIBuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbYLIBuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 20:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYLIBuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 20:50:00 -0500
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63776 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbYLIBuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 20:50:00 -0500
Message-ID: <493DCEC7.9050203@lwfinger.net>
Date: Mon, 08 Dec 2008 19:49:59 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to check for memory leaks
References: <493D9D24.8080406@lwfinger.net> <c62985530812081433o5125f08gb7cad0d33a1b4104@mail.gmail.com>
In-Reply-To: <c62985530812081433o5125f08gb7cad0d33a1b4104@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> 
> You could have a look on kmemleak: http://www.procode.org/kmemleak/
> It's up to date version is on the arm development git branch (topic kmemleak):
> http://www.linux-arm.org/git?p=linux-2.6.git;a=summary
> 

I downloaded the git tree, but x86_64 architecture won't build in the kmemtest
branch. I've built an i386 kernel that I will install on a different machine.
Once I get that working, I'll try to fix the other problem and post a patch.

Larry

