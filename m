Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbZCVV53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbZCVV53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 17:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZCVV5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 17:57:18 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:39114 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753876AbZCVV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 17:57:18 -0400
Date: Sun, 22 Mar 2009 23:00:32 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Rui Santos <rsantos@grupopie.com>,
       Michael =?unknown-8bit?B?QsO8a2Vy?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Message-ID: <20090322220032.GA23091@electric-eye.fr.zoreil.com>
References: <200903041828.49972.m.bueker@berlin.de> <49BE4EF6.3030406@grupopie.com> <20090322211159.GA23042@electric-eye.fr.zoreil.com> <200903222219.50112.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903222219.50112.mb@bu3sch.de>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Buesch <mb@bu3sch.de> :
[...]
> Thanks a lot. I will try these. Will take some time, because this is a
> production server and I'll have to take care to not completely bring it
> down. :)

Please note that Rui's device identifies as XID 0x3c400c0. Yours may need
something different (I do not remember seeing the XID in the thread back
in february).

-- 
Ueimor
