Return-Path: <linux-kernel-owner+w=401wt.eu-S937636AbYEUWGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937636AbYEUWGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759207AbYEUWGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:06:00 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:33839 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbYEUWF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:05:59 -0400
Message-ID: <48349CBB.4020509@freescale.com>
Date: Wed, 21 May 2008 17:05:47 -0500
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] Moving sound/* to drivers/ ?
References: <s5hzlqjz74d.wl%tiwai@suse.de>
In-Reply-To: <s5hzlqjz74d.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:

> If I understand correctly, with git, we can move the files in
> relatively little costs.  So, what about moving sound/* back to
> drivers/sound/* or drivers/media/sound/*?

That gets my vote.

-- 
Timur Tabi
Linux kernel developer at Freescale
