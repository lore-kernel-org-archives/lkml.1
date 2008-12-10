Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYLJCB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYLJCB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYLJCBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:01:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:51093 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbYLJCBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:01:18 -0500
Message-ID: <493F22CD.6060008@kernel.org>
Date: Wed, 10 Dec 2008 11:00:45 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] DMI: add dmi_match
References: <493E0689.6020302@garzik.org> <1228855948-22886-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1228855948-22886-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Dec 2008 02:00:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Add a wrapper for testing system_info which will handle also NULL
> system infos.
> 
> This will be used by the ata PIIX driver.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

Yeah, about ten times prettier this way.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
