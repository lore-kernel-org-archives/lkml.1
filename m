Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbYDUXPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbYDUXPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYDUXPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:15:08 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:40493 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbYDUXPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:15:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YTNKJu8W5OJjmaIASIMvulzHT7E0xUdNR1tjKXshBt0Mish946nU/LCfnJzZVis1m+/ZQY/sAOfY1PU9QUcaenjOaqXtyK6QNgJEIcCM4Xg31OQJrGgOPtpnrWbnUhfRGsCPduZTkVoSA3Yrar1RnuL5vsNe477MzJ9YQk9WafU=
Message-ID: <9a8748490804211615y25329beapf019d3c2907defe6@mail.gmail.com>
Date: Tue, 22 Apr 2008 01:15:06 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Please pull the (new) Trivial tree
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Jesper Juhl" <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull git://git.kernel.org/pub/scm/linux/kernel/git/juhl/trivial.git
for-linus

This is the (new) trivial tree.

I took over Trivial maintainership from Adrian Bunk and this is my
very first pull request as maintainer, so please let me know if I've
done anything wrong.

I know you have better things to do than look through trivial patches
(that's my job now), but since this is the very first tree I've
created I would ask you to please take the time to look it over
carefully. I cloned your tip-of-tree and then applied all the patches
I had filtered out to a 'for-linus' branch. I plan to then merge those
patches back from you into my 'master' branch once you've pulled, then
ditch my 'for-linus' branch and create a new one with new patches once
the next merge window opens - if that's not the right way to go about
it, please let me know.

To the various other tree maintainers; if there are patches in this
tree that I should not have merged and then told Linus to pull, but
should instead have sent to you, please tell me so I can do a better
job next time. I want to develop a good working relationship with
other maintainers, but I'm new at this and don't know exactely what to
do, so I've tried my best and hope it's good enough - but if not, I
want to be told so I can learn and do better in the future.

I've tried to not add patches that were already merged elsewhere as
well as patches that didn't really qualify as trivial. I hope I
succeeded.

Any and all comments on the tree I created, the patches in it etc are
more than welcome.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
