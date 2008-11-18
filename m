Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbYKRSOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbYKRSOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 13:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYKRSOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 13:14:08 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:57002 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYKRSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 13:14:08 -0500
Message-ID: <492305E7.9050906@nortel.com>
Date: Tue, 18 Nov 2008 12:13:59 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: rk@atr-labs.com
CC: =?ISO-8859-1?Q?Fredrik_Markstr=F6m?= 
	<fredrik.markstrom@avalonenterprise.com>,
       Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Developing non-commercial drivers ?
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com> <4922ED5A.3030808@shaw.ca> <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com> <4922F8C4.80509@nortel.com> <1227031253.1817.20.camel@win2k.atr-labs.com>
In-Reply-To: <1227031253.1817.20.camel@win2k.atr-labs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2008 18:14:02.0293 (UTC) FILETIME=[6F554650:01C949A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Radhakrishnan wrote:

> Am I therefore right in assuming that this is a specific case where the
> open source nature of Linux is being used with great effect but the very
> nature of the licensing denies ANYONE ELSE from being a party to this
> transaction ?

Actually, I think the GPL is still satisfied.  There's nothing that says 
that changes need to be passed upstream, only downstream.

1) Presumably you won't be distributing the binary drivers to anyone 
else, and you gave Organization A the code, so the license is satisfied.

2) Organization A has no other customers, so is not going to be 
distributing the binaries to anyone else.

3) The end-user (the Navy) was provided the source code for the GPL'd 
software that they purchased.

As far as I can tell, this is all fully GPL-compliant.

Chris
