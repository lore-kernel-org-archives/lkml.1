Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZLANyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZLANyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 08:54:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZLANyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 08:54:37 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:46450 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZLANyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 08:54:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=WcCM4STnV2KqKDoYhObJs+T6WBislOyJP52Q6OJfXkd6ZuY0MkmQ5nu1EVltvRZz7O
         sCeJj/l8KVQCnbD8U6qfiCl8dmd0jP4K85ERx2713IJ4pqY3pKxzdBTQMl/gxEKY7ANx
         fAyx5Ivpa8Ha5cqcSL5QNZQScGFN3feagiUYs=
Message-ID: <4B151FE2.3090807@gmail.com>
Date: Tue, 01 Dec 2009 15:53:38 +0200
From: Lior Dotan <liodot@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091201)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.32-rc8 - T500 fails to suspend to RAM
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ever since I've upgraded to rc8, my T500 fails to suspend to RAM for the
second time. Suspending for the first time works ok but when I resume and
later try to suspend again the screen gets blank and the moon LED blinks
forever. rc6 & rc7 as well as 2.6.31 worked great with out a problem.

Lior.

