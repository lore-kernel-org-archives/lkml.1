Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbYJLHWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbYJLHWh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 03:22:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYJLHWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 03:22:30 -0400
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:43518 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYJLHW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 03:22:29 -0400
X-Greylist: delayed 47042 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2008 03:22:29 EDT
Message-ID: <48F1A789.3060707@numericable.fr>
Date: Sun, 12 Oct 2008 09:30:17 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008092811)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [2.6.27-git2] compilation warning for arch/x86/kernel/xsave.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,


Your commit ed405958057ca6a8c4c9178a7a3b1167fabb45f5 causes this 
compilation warning on xsave.c :

> arch/x86/kernel/xsave.c: In function ‘save_i387_xstate’:
> arch/x86/kernel/xsave.c:98: attention : ignoring return value of 
> ‘__clear_user’, declared with attribute warn_unused_result

Regards.

