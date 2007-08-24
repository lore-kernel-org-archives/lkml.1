Return-Path: <linux-kernel-owner+w=401wt.eu-S964891AbXHXAiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891AbXHXAiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933837AbXHXAhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:37:55 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:27321 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933750AbXHXAhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:37:53 -0400
In-Reply-To: <91dcfc2a1b0be436d04f9bc45bb6f8657a8d6ff4.1187912217.git.jesper.juhl@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Heiko J Schick <schickhj@de.ibm.com>, Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>
MIME-Version: 1.0
Subject: Re: [PATCH 04/30] powerpc: Don't cast kmalloc return value in ibmebus.c
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OFAB12DB94.3E0F2BF6-ONC1257341.00034D6B-C1257341.00037513@de.ibm.com>
Date: Fri, 24 Aug 2007 02:37:49 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 24/08/2007 02:37:50,
	Serialize complete at 24/08/2007 02:37:50
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> kmalloc() returns a void pointer so there is absolutely no need to
> cast it in ibmebus_chomp().
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

Acked-By: Joachim Fenkes <fenkes@de.ibm.com>

