Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZBZAjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZBZAjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 19:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZBZAjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 19:39:23 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51862 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZBZAjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 19:39:22 -0500
Date: Thu, 26 Feb 2009 01:39:20 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: arnd@arndb.de, Sam Ravnborg <sam@ravnborg.org>,
       Kyle McMartin <kyle@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>, mingo@redhat.com,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, netfilter-devel@vger.kernel.org,
       coreteam@netfilter.org
Subject: Re: [patch 5/7] make netfilter use strict integer types
In-Reply-To: <49A5DECD.7090809@zytor.com>
Message-ID: <alpine.LSU.2.00.0902260137001.23768@fbirervta.pbzchgretzou.qr>
References: <20090225235138.062045835@arndb.de> <20090225235515.682333715@arndb.de> <alpine.LSU.2.00.0902260104220.20789@fbirervta.pbzchgretzou.qr> <49A5DECD.7090809@zytor.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2009-02-26 01:14, H. Peter Anvin wrote:
>>[...]
>> IMHO, __uXX should be replaced by uintX_t, but a move this great I
>> will leave to future generations because there is just too much
>> persisting opinions wrt. such proposal. As such I'd like to join
>> and persist on my position and that uintX that we have should be kept.
>
> We *CAN'T* replace __uXX with uintX_t.  Period, full stop, end of story.

Would the mindful master please elaborate why this is so, if it is
indeed not a personal decision.
