Return-Path: <linux-kernel-owner+w=401wt.eu-S1763229AbXKIPst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763229AbXKIPst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbXKIPsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:48:41 -0500
Received: from mailgw.infracomspa.it ([217.12.183.244]:2257 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752807AbXKIPsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:48:40 -0500
Message-ID: <47348151.3040202@infracomspa.it>
Date: Fri, 09 Nov 2007 16:48:33 +0100
From: Roberto Oppedisano <roppedisano@infracomspa.it>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: libata: cdrw/dvdrom disabed after s2ram (2.6.24-rc2)
References: <4731C86B.1040704@infracomspa.it> <20071107121355.5eaf4496.akpm@linux-foundation.org> <47333CCF.1050403@infracomspa.it> <20071108094958.5c9b1b22.akpm@linux-foundation.org> <20071108180256.GB3491@havoc.gtf.org>
In-Reply-To: <20071108180256.GB3491@havoc.gtf.org>
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 11/09/2007 04:48:34 PM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 09/11/2007 16.48.40,
	Serialize complete at 09/11/2007 16.48.40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote, On 11/08/2007 07:02 PM:
> Set module option "noacpi" to 1, to disable ACPI and see if that fixes
> the problem.
>   
Booting with libata.noacpi=1 fixes the problem too.

R
