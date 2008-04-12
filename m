Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYDLPl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYDLPl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYDLPlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:41:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:2239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbYDLPlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=HEYiy6lHoMlUXOByTvpPGrw5ls9CfXSi6F/k81IEQRAJA56vptB0UcnmWf2l7UDG98om8Jd70Vqknmhh1a8cWpg9EqMlNBXh4+O+py9dtTjVmCcaKLeBjBbxgz9fume/goAl4N9HT7RcAJ/f0t8+Km0WjGmA/ad3xCuZsvJu+yM=
Message-ID: <4800D743.3000405@gmail.com>
Date: Sat, 12 Apr 2008 17:37:39 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: [PATCH 0/3] x86: more section mismatch fixes
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

those are patches which fixes some section mismatch stuff in 32-bit part of arch/x86.

@Ingo, I hope that this time everything will be perfect ;-)


-Jacek
