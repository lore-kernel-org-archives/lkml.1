Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYGHDbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYGHDbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 23:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbYGHDbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 23:31:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbYGHDbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 23:31:24 -0400
Message-ID: <4872DF7F.30406@kernel.org>
Date: Mon, 07 Jul 2008 20:31:11 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, webmaster@kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: git pull through http / git
References: <48724130.5050501@atmel.com> <alpine.LNX.1.10.0807071840470.8248@fbirervta.pbzchgretzou.qr> <48725A7F.7040409@kernel.org> <alpine.LNX.1.10.0807072052510.8248@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LNX.1.10.0807072052510.8248@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> 
>> I have made some sketches on a git-aware http protocol to deal with 
>> the "idiot IT department-managed firewall" problem; however, I have 
>> not had time to implement it.
> 
> Not wanting to downplay your work, but I'd be happier if they
> would not get to have their githttp in the hope  that these
> IT departments get a clue that http is not a fits-it-all solution.
> 
> Because once the workers can't do their job because the world is 
> Git-dominated, they have to turn it on. But maybe then they still don't 
> get the clue...hmm
> tricky situation :)
> 

Given that one of the companies so affected is Intel, which you'd think 
would have more of a clue not just for git but for God-knows-how-many 
other services...

	-hpa
