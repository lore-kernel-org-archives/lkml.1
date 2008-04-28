Return-Path: <linux-kernel-owner+w=401wt.eu-S936621AbYD1TdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936621AbYD1TdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935148AbYD1TcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:32:22 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:51320 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934827AbYD1TcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:32:20 -0400
Message-ID: <48161EA7.2090209@grupopie.com>
Date: Mon, 28 Apr 2008 19:59:51 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] kallsyms updates for Blackfin
References: <1209119299-27894-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1209119299-27894-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> These patches were sent out before and acked by you.
> Could you please merge these?

I don't actually merge patches... these will have to go through Andrew 
(CC'ed).

Just make sure they are still compatible with the latest -mm tree, 
because there have been a few patches floating around lately that 
touched kallsyms.

-- 
Paulo Marques - www.grupopie.com

"To know recursion, you must first know recursion."
