Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbYFMNWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbYFMNWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 09:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYFMNV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 09:21:58 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:12580 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbYFMNV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 09:21:58 -0400
Date: Fri, 13 Jun 2008 15:21:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Klaus S. Madsen" <ubuntu@hjernemadsen.org>
Cc: maximilian attems <max@stro.at>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Chuck Short <zulcss@ubuntu.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH] hdaps add support for various IBM thinkpads
 R61/T61/T61P
Message-ID: <20080613152145.7e93b8fa@hyperion.delvare>
In-Reply-To: <20080613124543.GK30713@42.dk>
References: <1213356407-1220-1-git-send-email-max@stro.at>
	<20080613114002.GJ30713@42.dk>
	<20080613122751.GF7212@baikonur.stro.at>
	<20080613124543.GK30713@42.dk>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 14:45:43 +0200, Klaus S. Madsen wrote:
> But as I stated in that bug description, the fix did not work for me.
> Also both R61, T60, T61 and T61p owners responded that their
> dmi-manufacturer was listed as LENOVO. So I'm quite dubious if these
> entries will match any machines at all?

FWIW, my T61p has LENOVO as the manufacturer in the DMI table, too.

-- 
Jean Delvare
