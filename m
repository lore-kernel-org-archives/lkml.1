Return-Path: <linux-kernel-owner+w=401wt.eu-S1757687AbYATC1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687AbYATC1c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 21:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYATC1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 21:27:22 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:42112 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYATC1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 21:27:22 -0500
Message-ID: <4792B191.2060801@davidnewall.com>
Date: Sun, 20 Jan 2008 12:57:29 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH for mm] Remove iBCS support
References: <20080119045918.GA12215@basil.nowhere.org>
In-Reply-To: <20080119045918.GA12215@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Can you please queue this patch in -mm for .25. It was posted earlier
> and nobody complained.

I'm sure I complained.  I'm sure I said something about SCO
compatibility.  This is a sleeping giant for Linux.  There are plenty of
machines running legacy SCO applications, just waiting for painless
migration to some other platform.

We should not be dismantling the scaffolding that's needed for that.
