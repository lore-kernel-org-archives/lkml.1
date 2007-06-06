Return-Path: <linux-kernel-owner+w=401wt.eu-S1763307AbXFFLUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763307AbXFFLUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbXFFLU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:20:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6940 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551AbXFFLUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:20:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=gllnCHvvi7gjB+PWJgf1lVRQwpadL7cY0PxYfnoaiemBDQ4cI5pfWcVKvNV9FFV8JePboot5oW+9vBZKBOi5AQN/UVuPqfL04MKusIRLYs1c4wd2apdhmDWr7C+4Wjjmlfc/njCZTdA/mEMLeizcnwzZb8Gp/8LXanmFnBiGlxw=
Message-ID: <4666987E.1060608@gmail.com>
Date: Wed, 06 Jun 2007 13:20:30 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: serio interface
References: <46667A3B.8070708@gmx.de>
In-Reply-To: <46667A3B.8070708@gmx.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lars K.W. Gohlke napsal(a):
> hallo,
> 
> wouldsomebody explain me the serio interface or give me a code link for
> very simple example.

Something like this?
http://examples.oreilly.com/linuxdrive3/

examples/tty/tiny_serial.c

Some things are obsoleted, but main code flow remains.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
