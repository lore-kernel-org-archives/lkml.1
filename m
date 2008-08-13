Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYHMWYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYHMWYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 18:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYHMWYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 18:24:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751654AbYHMWYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 18:24:23 -0400
Date: Wed, 13 Aug 2008 15:24:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc3
In-Reply-To: <20080813110316.1d9af655@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0808131522330.3462@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808121914270.3462@nehalem.linux-foundation.org> <20080813110316.1d9af655@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Aug 2008, Alan Cox wrote:
>
> (If it looks ok let me know .. it'll also apply for testing versus -rc but
>  wants a final polish in that form)

Looks ok. It's biggish, but looks pretty straightforward, and a fair chunk 
of it seems to be the comment changes/additions. So send some final 
version over when the polish is done..

		Linus
