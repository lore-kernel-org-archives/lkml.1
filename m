Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYGGTy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYGGTy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYGGTyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:54:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754974AbYGGTyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:54:46 -0400
Date: Mon, 7 Jul 2008 12:54:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsprintf: fix gcc warning
In-Reply-To: <20080707192429.GA17551@damson.getinternet.no>
Message-ID: <alpine.LFD.1.10.0807071247480.11076@woody.linux-foundation.org>
References: <20080707192429.GA17551@damson.getinternet.no>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jul 2008, Vegard Nossum wrote:
> 
> Does this look correct? Please disregard this if it has already
> been fixed. Thanks.

Looks fine. But the series I eventually committed avoided this issue, so 
please double-check current -git.

		Linus
