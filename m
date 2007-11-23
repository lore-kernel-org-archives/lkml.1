Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbXKWLkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbXKWLkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 06:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbXKWLkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 06:40:47 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59833 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbXKWLkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 06:40:46 -0500
Message-ID: <4746BC2B.6060002@bull.net>
Date: Fri, 23 Nov 2007 12:40:27 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH 2.6.24-rc3-mm1] IPC: make struct ipc_ids static in ipc_namespace
References: <20071122155448.3193c856.pierre.peiffer@bull.net> <474680B5.7020104@fr.ibm.com> <47468347.5090303@openvz.org> <47468927.3040304@openvz.org> <47469630.3060807@bull.net> <47469CF3.1030200@openvz.org> <4746B027.4020506@bull.net> <4746B449.5010204@openvz.org>
In-Reply-To: <4746B449.5010204@openvz.org>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/11/2007 12:47:49,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 23/11/2007 12:47:51,
	Serialize complete at 23/11/2007 12:47:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> Well I think you're right. The structure gains 50% in size... Really too
> much to fight for performance in IPC :)
> 
> Thanks for checking this thing.
> 
> You may put my Acked-by in the original patch.
> 

Cool. Thanks !

P.

> Thanks,
> Pavel
> 

-- 
Pierre Peiffer
