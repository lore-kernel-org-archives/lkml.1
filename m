Return-Path: <linux-kernel-owner+w=401wt.eu-S1762066AbZLLLg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066AbZLLLg6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 06:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761846AbZLLLg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 06:36:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZLLLg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 06:36:57 -0500
Message-ID: <4B238067.4050201@suse.cz>
Date: Sat, 12 Dec 2009 12:37:11 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
Cc: nir.tzachar@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org,
       =?UTF-8?B?IlZhZGltIEJlbmRlYnVyeSAo0LLQsSki?= <vbendeb@google.com>
Subject: Re: nconfig v7
References: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> - For symbol info, it would be cool if it wrapped the "Selected by"
>   line (menuconfig also "suffers" from this), because that one can
>   get exceptionally long and awkward to scroll.

Vadim Bendebury recently sent a patch to address this in menuconfig.
Once done, it should be trivial to apply it to nconfig, too. See
http://patchwork.kernel.org/patch/66287/

Michal
