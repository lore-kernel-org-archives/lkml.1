Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYGGOez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYGGOez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 10:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbYGGOer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 10:34:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbYGGOeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 10:34:46 -0400
Message-ID: <48722996.4050601@redhat.com>
Date: Mon, 07 Jul 2008 10:35:02 -0400
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
CC: "Schoeller, Patrick (Linux - Houston, TX)" <Patrick.Schoeller@hp.com>
Subject: bfsort whitelist patch apparently applied twice
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the most recent pull from Linus' tree, I see that the patch
I submitted on 14-May-2008 was merged twice in the git log.

  commits: a16b4bcd31a73a81b6d2b8ffa6b5f6ed01cf6d64
      and: a1676072558854b95336c8f7db76b0504e909a0a

The result is that now the DL360 and DL380 are whitelisted twice
and the DL385 G2 and DL585 G2 are not whitelisted at all!

Can one of these redundant commits be backed out?

Thanks and regards,
Tony

