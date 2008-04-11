Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbYDKLcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbYDKLcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 07:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbYDKLcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 07:32:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:29810 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759490AbYDKLcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=gIySNAlsVqfxkcCEHBm23odWhixts/dA59YIb35uSHceJ+ZlMtbSZAQMVq/rZwFlBbW0ExfkpNTpYM6yGAX6/JX6lf5fToCwR12CZR2JIxy/Pw/IgBKqWB+lfxdYYsaMoa5hbAi++6HX2XtWgORVRh80EBYE4NV1kD/uuOVHChA=
Message-ID: <47FF4B54.50402@gmail.com>
Date: Fri, 11 Apr 2008 13:28:20 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de, linux-next@vger.kernel.org
Subject: [PATCH 0/3] x86: Section mismatch fixes
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

those patches fixes some section mismatch warnings, which appear on x86_64 with linux-next-200804[09,10,11].
It's continuation of work on section mismatches which result in two patches send previously:
	- http://lkml.org/lkml/2008/4/10/88
	- http://lkml.org/lkml/2008/4/10/290

Patches are against x86/latest.

-Jacek
