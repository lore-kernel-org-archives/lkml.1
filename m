Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYKGOwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYKGOwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYKGOw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:52:28 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:56066 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437AbYKGOw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:52:27 -0500
Message-ID: <49145628.7030804@euromail.se>
Date: Fri, 07 Nov 2008 15:52:24 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "J.R. Mauro" <jrm8005@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Add a detailed multi-touch finger data report
 protocol
References: <49142351.9080805@euromail.se>	 <3aaafc130811070534p54eebeb6q9b57d3e847ed859a@mail.gmail.com>	 <49145016.7090206@euromail.se> <3aaafc130811070636g681accf5qae252679c2edcdb9@mail.gmail.com>
In-Reply-To: <3aaafc130811070636g681accf5qae252679c2edcdb9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1KyShF-0007HQ-6Z.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1KyShF-0007HQ-6Z 46bcecbb5ea2516dd3ad725c429be001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Have you worked with MPX? Or was a vanilla-X11 driver simple enough?
> How does this all get presented to userspace applications? Multiple
> mouse inputs or special stuff that applications would need a rewrite
> to leverage?

MPX is about making use of multiple pointers. The MT protocol is about
making use of multiple fingers. It can in principle be used as input
to MPX applications; I will bring it up with Peter Hutterer. However,
the main aim is to bring advanced gestures to the linux desktop.

Henrik

