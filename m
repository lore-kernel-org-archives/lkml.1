Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbZFNAIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbZFNAIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 20:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbZFNAIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 20:08:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbZFNAII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 20:08:08 -0400
Date: Sat, 13 Jun 2009 17:07:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Anton Zinoviev <anton@lml.bas.bg>
Subject: Re: [PATCH] advertise KT_DEAD2
In-Reply-To: <20090613125233.GH5181@const.famille.thibault.fr>
Message-ID: <alpine.LFD.2.01.0906131707050.3237@localhost.localdomain>
References: <20090613125233.GH5181@const.famille.thibault.fr>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Jun 2009, Samuel Thibault wrote:
>
> In addition to KT_DEAD which has limited support for diacriticals, there
> is KT_DEAD2 that can support 256 criticals, so let's advertise it in
> <linux/keyboard.h>.

Can you do more of an explanation for this? KT_DEAD2 does not show up in a 
kernel grep, so..

		Linus
