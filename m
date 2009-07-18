Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbZGRIfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbZGRIfb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 04:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbZGRIf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 04:35:26 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54372 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbZGRIfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 04:35:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A618948.9040805@s5r6.in-berlin.de>
Date: Sat, 18 Jul 2009 10:35:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Ozkan Sezer <sezeroz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 0/8] 2.6.27.27-stable review
References: <647fe9b10907172344q5b01d356me8f47c4d50755bdb@mail.gmail.com>
In-Reply-To: <647fe9b10907172344q5b01d356me8f47c4d50755bdb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ozkan Sezer wrote:
> You may want to review this:
> http://lkml.org/lkml/2009/7/3/36
> .. and its follow-up:
> http://lkml.org/lkml/2009/7/3/294
> .. and this old one (can't believe it's still there) :
> http://lkml.org/lkml/2008/12/3/463

Well, why don't /you/ review these issues?  (Are these bugs which meet 
the criteria enumerated in Documentation/stable_kernel_rules.txt?  Is 
there a fix in mainline which can be taken over as-is or in similar form 
for 2.6.x.y?)

If the answer to both is yes, submit patches as described in 
stable_kernel_rules.txt.

If you are not quite sure about the criteria, discuss the bugs and their 
fixes with the respective maintainers who should know them well enough 
to judge whether they are -stable material.
-- 
Stefan Richter
-=====-==--= -=== =--=-
http://arcgraph.de/sr/
