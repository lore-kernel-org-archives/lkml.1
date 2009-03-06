Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbZCFWlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbZCFWlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbZCFWlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:41:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757786AbZCFWlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:41:00 -0500
Date: Fri, 6 Mar 2009 14:38:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sonic.zhang@analog.com, cooloney@kernel.org
Subject: Re: [PATCH 04/18] Blackfin Serial Driver: Change hardware
 flowcontrol from poll to interrupt driven.
Message-Id: <20090306143806.3b126ab4.akpm@linux-foundation.org>
In-Reply-To: <1236321780-28718-5-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-5-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:42:46 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Only CTS bit is affected.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

Another completely useless changelog.

Your [PATCH 00/18] email described all these patches as
needed-in-2.6.29 bugfixes.  As far as I can tell (based on almost zero
information), this patch is not a bugfix.


