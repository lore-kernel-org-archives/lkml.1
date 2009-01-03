Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbZACX0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbZACX0E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:26:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760090AbZACXZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:25:54 -0500
Received: from styx.suse.cz ([82.119.242.94]:46245 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760088AbZACXZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:25:53 -0500
Date: Sun, 4 Jan 2009 00:25:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Baodong Chen <chenbdchenbd@gmail.com>, Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Documentation/x86/boot.txt:payload length was changed
 to payload_length
In-Reply-To: <d204e3110901022037i4c0e077ck6cefcf35f6048318@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0901040024560.5377@jikos.suse.cz>
References: <d204e3110901022037i4c0e077ck6cefcf35f6048318@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Ingo to CC ]

Ingo, I guess you are going to take the patch through x86 tree, so I 
wouldn't bother merging it through trivial tree, right?

Thanks.

-- 
Jiri Kosina

On Sat, 3 Jan 2009, Baodong Chen wrote:

> Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>
> 
> ---
>  Documentation/x86/boot.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> index fcdc62b..7b4596a 100644
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -44,7 +44,7 @@ Protocol 2.07:	(Kernel 2.6.24) Added paravirtualised
> boot protocol.
> 		and KEEP_SEGMENTS flag in load_flags.
> 
>  Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
> -		payload. Introduced payload_offset and payload length
> +		payload. Introduced payload_offset and payload_length
> 		fields to aid in locating the payload.
> 
>  Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
> --
> 1.5.3.3
> 

