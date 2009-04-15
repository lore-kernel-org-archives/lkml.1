Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbZDOKDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbZDOKDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZDOKC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:02:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56853 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758548AbZDOKCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:02:55 -0400
Date: Wed, 15 Apr 2009 12:02:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Trivial: fix typo s/balence/balance/
In-Reply-To: <1239761657-16555-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LNX.2.00.0904151202460.13028@wotan.suse.de>
References: <1239761657-16555-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  include/linux/ultrasound.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ultrasound.h b/include/linux/ultrasound.h
> index 6b7703e..71339dc 100644
> --- a/include/linux/ultrasound.h
> +++ b/include/linux/ultrasound.h
> @@ -34,7 +34,7 @@
>   *		_GUS_VOICEOFF	- Stops voice (no parameters)
>   *		_GUS_VOICEFADE	- Stops the voice smoothly.
>   *		_GUS_VOICEMODE	- Alters the voice mode, don't start or stop voice (P1=voice mode)
> - *		_GUS_VOICEBALA	- Sets voice balence (P1, 0=left, 7=middle and 15=right, default 7)
> + *		_GUS_VOICEBALA	- Sets voice balance (P1, 0=left, 7=middle and 15=right, default 7)
>   *		_GUS_VOICEFREQ	- Sets voice (sample) playback frequency (P1=Hz)
>   *		_GUS_VOICEVOL	- Sets voice volume (P1=volume, 0xfff=max, 0xeff=half, 0x000=off)
>   *		_GUS_VOICEVOL2	- Sets voice volume (P1=volume, 0xfff=max, 0xeff=half, 0x000=off)
> -- 

Applied to trivial tree, thanks.

-- 
Jiri Kosina
SUSE Labs
