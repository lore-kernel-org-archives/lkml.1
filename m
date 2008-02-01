Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbYBAPpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbYBAPpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYBAPpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:45:36 -0500
Received: from gw.goop.org ([64.81.55.164]:53677 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbYBAPpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:45:35 -0500
Message-ID: <47A33E80.7090509@goop.org>
Date: Fri, 01 Feb 2008 07:45:04 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Campbell <ijc@hellion.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: PAE swapper_pg_dir needs to be page-sized
References: <47A251E9.4050606@goop.org> <1201856044.3804.1.camel@cthulhu.hellion.org.uk> <20080201132821.GB11070@elte.hu>
In-Reply-To: <20080201132821.GB11070@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> thanks, applied. I'm wondering, where did we break that?
>   

In the "PAE from boot" patch, I would guess.

    J
