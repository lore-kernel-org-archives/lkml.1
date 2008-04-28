Return-Path: <linux-kernel-owner+w=401wt.eu-S937334AbYD1Tcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937334AbYD1Tcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934039AbYD1TcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:32:21 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:51319 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873AbYD1TcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:32:20 -0400
X-Greylist: delayed 1946 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 15:32:20 EDT
Message-ID: <48161F0A.4030806@grupopie.com>
Date: Mon, 28 Apr 2008 20:01:30 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: linux-kernel@vger.kernel.org, Robin Getz <robin.getz@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] kallsyms: Allow kernel symbols in L1 to be found
 in Blackfin architecture
References: <1209119299-27894-1-git-send-email-cooloney@kernel.org> <1209119299-27894-2-git-send-email-cooloney@kernel.org>
In-Reply-To: <1209119299-27894-2-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Robin Getz <robin.getz@analog.com>
> 
> Add _stext_l1, _etext_l1 for the L1 memory section in Blackfin.
> 
> Signed-off-by: Robin Getz <robin.getz@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---

Signed-off-by: Paulo Marques <pmarques@grupopie.com>

-- 
Paulo Marques - www.grupopie.com

"Who is general Failure and why is he reading my disk?"
