Return-Path: <linux-kernel-owner+w=401wt.eu-S1760817AbXGaM5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbXGaM5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 08:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758876AbXGaM5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 08:57:00 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:2427 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524AbXGaM47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 08:56:59 -0400
Date: Tue, 31 Jul 2007 14:57:40 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 3/7] sysfs: cosmetic changes in sysfs_lookup()
Message-ID: <20070731145740.7c0b22c8@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11858769083801-git-send-email-htejun@gmail.com>
References: <11858769082982-git-send-email-htejun@gmail.com>
	<11858769083801-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 19:15:08 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> * remove space between * and symbol name in variable declaration.
> 
> * kill unnecessary new line.
> 
> * kill 'found' and test 'sd' instead.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  fs/sysfs/dir.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)
> 
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
