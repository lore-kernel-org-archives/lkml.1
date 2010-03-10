Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab0CJP6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:58:32 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:59149 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab0CJP6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:58:31 -0500
Message-ID: <4B97C170.6010809@inf.tu-dresden.de>
Date: Wed, 10 Mar 2010 16:57:36 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre) Gecko/20100217 Shredder/3.0.3pre
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Evan McClain <evan.mcclain@gatech.edu>, rpurdie@rpsys.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backlight: mbp_nvidia_bl - add five more MacBook	variants
References: <1268180458-1844-1-git-send-email-evan.mcclain@gatech.edu> <20100310142424.GA21625@srcf.ucam.org> <4B97BEA7.8010804@inf.tu-dresden.de> <20100310154752.GA23027@srcf.ucam.org>
In-Reply-To: <20100310154752.GA23027@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10.03.2010 16:47, Matthew Garrett wrote:
> On Wed, Mar 10, 2010 at 04:45:43PM +0100, Mario Schwalbe wrote:
>
>> Tested using a simple program that writes the ports from userland.
>> And ack: it should probably be renamed to something more reasonable.
>> Something like apple_bl?
>
> Sure. Want to do a patch for that and Kconfig? It probably wants a
> module alias line for backwards compatibility.

Why not? How should the module alias line look like?
MODULE_ALIAS("mbp_nvidia_bl");
Or prefixed with some subsystem identifier? I've never used it before.

Thanks & ciao,
Mario
