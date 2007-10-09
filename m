Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXJIAVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXJIAVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 20:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXJIAVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 20:21:35 -0400
Received: from gw.goop.org ([64.81.55.164]:34731 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbXJIAVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 20:21:34 -0400
Message-ID: <470AC959.1050508@goop.org>
Date: Mon, 08 Oct 2007 17:20:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: how to tell it multiple pte locks is OK?
References: <47087D45.2010904@goop.org>	<20071007095853.13a8755d@laptopd505.fenrus.org>	<C2543D65-1241-47E6-8C06-BF6E4F73E19A@goop.org> <20071007104658.655565e3@laptopd505.fenrus.org>
In-Reply-To: <20071007104658.655565e3@laptopd505.fenrus.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> s/implemented/merged/ :)
>
> IN fact shared pagetables are already there for hugepages.
> For small pages it's a patch at this point.
>   

Is it kept up to date?  Where does it live?

> no I'm not saying that. I'm just saying that I'm worried about the
> locking robustness of your trick in general.
>   

Hm, well I won't need to re-pin shared ptes anyway, so I think it's moot.

    J
