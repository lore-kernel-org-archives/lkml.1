Return-Path: <linux-kernel-owner+w=401wt.eu-S965233AbXCGNBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233AbXCGNBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 08:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965236AbXCGNBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 08:01:44 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37972 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965233AbXCGNBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 08:01:43 -0500
Message-ID: <45EEB777.20709@bull.net>
Date: Wed, 07 Mar 2007 14:00:39 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: tglx@linutronix.de
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-15?Q?S=E9bastien_Du?= =?ISO-8859-15?Q?gu=E9?= 
	<sebastien.dugue@bull.net>
Subject: Re: How to distinguish original kernel vs -rt kernel
References: <45EE8829.4060304@bull.net> <1173261291.24738.581.camel@localhost.localdomain>
In-Reply-To: <1173261291.24738.581.camel@localhost.localdomain>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 07/03/2007 14:03:24,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 07/03/2007 14:03:26,
	Serialize complete at 07/03/2007 14:03:26
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner a écrit :

> 
> It is HRTIMER_MODE_xx in mainline as of 2.6.21-rc1. -rt kernels are
> always a bit ahead of time. :)

Great !
Thanks.

-- 
Pierre
