Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbXK1KRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbXK1KRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXK1KRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:17:32 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:34779 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbXK1KRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:17:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=r5uxxU40vBU7ndpyM1VWDXgbuL3mdTqQTvo6zWkf6VeS8OYscP1ixfx9wNhGOAfcxko6yLMtK6OpO/p9e8KNY+o8ub+wo/LLU2ZnaNwgtkT0Pjz0xrUbbNEyQPOOz3Rr5uFXijASsUvbzaa+xWHIHtpN44aK4Iv2N8Qt4lvq1SU=
Message-ID: <e85b9d30711280217j104f3117oac4a0fe5bedb5cf1@mail.gmail.com>
Date: Wed, 28 Nov 2007 11:17:28 +0100
From: Matthew <jackdachef@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: CFS scheduler, -v24, for v2.6.24-rc3-git3 / current git state
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo & the other contributors of CFS,

I just wanted to say thank you for your excellent job on this scheduler :)

I didn't want to tell anything about v24 too fast since testing takes
its time ;)

so here my experience so far:

- no sound stuttering anymore during internet sound streaming even
during heavy compiling (maybe there's still stuttering but I can't
hear it *g*)
- desktop feels really responsive
- even firefox with around 30 tabs and fully used memory (4 GB) &
fully used swap (2.5 GB) stil feels quite responsive & great to work
with (probably it's also thanks to ck-patchset I'm using besides cfs
-> zen-sources)
- haven't tested 3d FPS so can't tell

keep up the great work !

Greetings

Mat
