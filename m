Return-Path: <linux-kernel-owner+w=401wt.eu-S1764262AbXLMW1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764262AbXLMW1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 17:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759986AbXLMW1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 17:27:34 -0500
Received: from gw.goop.org ([64.81.55.164]:38773 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759028AbXLMW1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 17:27:33 -0500
Message-ID: <4761B1C3.2000606@goop.org>
Date: Thu, 13 Dec 2007 14:27:15 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 1/3] x86: clean up asm-x86/page*.h
References: <476030CE.4050203@goop.org> <20071213102110.GP8977@elte.hu> <47619D0D.4010909@goop.org> <20071213213226.GA11442@elte.hu>
In-Reply-To: <20071213213226.GA11442@elte.hu>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> You can force git to non-append jump-pull the remote via changing 
> .git/refs/remotes/origin/HEAD from:
>
>  ref: refs/remotes/origin/master
>
> to:
>
>  ref: +refs/remotes/origin/master
>   

This just gets me lots of "error: refs/remotes/origin/HEAD points
nowhere!" messages.  Maybe it will work now I've properly set up a local
branch to track the remote branch.  We'll see...

    J
