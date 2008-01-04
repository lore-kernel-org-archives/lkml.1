Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYADN7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYADN7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbYADN5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:57:09 -0500
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:51011
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbYADN5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:57:07 -0500
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2008 08:57:06 EST
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
References: <1199452896-20145-1-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-2-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx>
	<1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx>
	<477E379F.4000103@student.ltu.se>
From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Date: Fri, 04 Jan 2008 14:47:24 +0100
In-Reply-To: <477E379F.4000103@student.ltu.se> (Richard Knutsson's message of "Fri\, 04 Jan 2008 14\:41\:51 +0100")
Message-ID: <8763y9em8j.fsf@barad-dur.regala.cx>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vous m'avez dit récemment :

[snip]

> Hi Mathieu
>
> What about changing the __FUNCTION__ to __func__, while you are at it?

well, won't do any harm, even though other compilers than GCC are not
officialy supported :)

thanks a lot
And I think I will revamp, including fixes into fs/ext2

-- 
Mathieu
