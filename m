Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYCCQTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYCCQTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754504AbYCCQTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:19:01 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:59753 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbYCCQTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:19:00 -0500
Message-ID: <47CC24AD.1090409@panasas.com>
Date: Mon, 03 Mar 2008 18:17:49 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Richard Knutsson <ricknu-0@student.ltu.se>, SL Baur <steve@xemacs.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: multiple updates
References: <1204062430.47c488def40a4@portal.student.luth.se>	<20080226135444.f83a0536.randy.dunlap@oracle.com>	<Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>	<Pine.LNX.4.64.0802270033310.5714@axis700.grange>	<m31w6zcm4l.fsf@maximus.localdomain>	<ed10ee420802261657w3830e1a1rf0cc9601cdacb142@mail.gmail.com>	<20080226213432.1388717b.randy.dunlap@oracle.com>	<47C5DDE0.3040403@student.ltu.se>	<ed10ee420802271611l3a09e76ej531158f167512a03@mail.gmail.com>	<47C71510.6060306@student.ltu.se> <m3skzb9ysw.fsf@maximus.localdomain>
In-Reply-To: <m3skzb9ysw.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 01, 2008, 0:34 +0200, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Richard Knutsson <ricknu-0@student.ltu.se> writes:
> 
>> In those cases, an only-used-as-indent-character is most preferable.
> 
> It is. The problem is that the editors can't do it (yet?). Or am I
> mistaken?

"Yet" is the right answer :)
When creating a new line copying the indentation from the line above
and potentially filling more spaces as needed, according to
parenthesis or operators on the previous line should do the trick.

Benny

