Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYKGPH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYKGPH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 10:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYKGPHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 10:07:14 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:36929 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752000AbYKGPHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 10:07:13 -0500
Message-ID: <4914599D.9060403@euromail.se>
Date: Fri, 07 Nov 2008 16:07:09 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "J.R. Mauro" <jrm8005@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
 protocol
References: <49142351.9080805@euromail.se>	 <3aaafc130811070534p54eebeb6q9b57d3e847ed859a@mail.gmail.com>	 <49145016.7090206@euromail.se>	 <3aaafc130811070636g681accf5qae252679c2edcdb9@mail.gmail.com>	 <49145628.7030804@euromail.se> <3aaafc130811070657o63894848l3c11989c9b0f2911@mail.gmail.com>
In-Reply-To: <3aaafc130811070657o63894848l3c11989c9b0f2911@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KySvW-0002jt-7b.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KySvW-0002jt-7b 2b7fab43b9c2d86a2ad76ab04a3bf1e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think this approach is cleaner than "fooling" userspace into seeing
> a bunch of mice.

The many-input-device approach has problems with synchronicity. In
particular when envisioning the appearance of more advanced chips,
with finger matching in hardware. Currently, no chip with open or
sufficient documentation has these features, but it is probably
only a matter of time.
