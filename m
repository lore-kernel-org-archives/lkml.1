Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZJCSQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZJCSQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 14:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZJCSQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 14:16:50 -0400
Received: from vbn.0050556.lodgenet.net ([216.142.194.234]:34361 "EHLO
	vbn.0050556.lodgenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776AbZJCSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 14:16:49 -0400
X-Greylist: delayed 2156 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Oct 2009 14:16:49 EDT
Subject: Re: [PATCH] lcd: Fix wrong sizeof
From: Richard Purdie <rpurdie@rpsys.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
In-Reply-To: <20091002112818.54428c49@hyperion.delvare>
References: <20091002112818.54428c49@hyperion.delvare>
Content-Type: text/plain
Date: Sat, 03 Oct 2009 18:01:49 +0100
Message-Id: <1254589309.19472.6.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-02 at 11:28 +0200, Jean Delvare wrote:
> Which is why I have always preferred sizeof(struct foo) over
> sizeof(var).
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> ---
> Stable team, this one applies to 2.6.31, 2.6.30 and 2.6.27.

Queued in the backlight tree. I'll wait to see if any other fixes appear
for backlights send to Linus in a few days.

Cheers,

Richard
-- 
Richard Purdie
Intel Open Source Technology Centre

