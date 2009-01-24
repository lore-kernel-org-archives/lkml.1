Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZAXEmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZAXEmY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 23:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZAXEmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 23:42:15 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:54783 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754485AbZAXEmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 23:42:14 -0500
Message-ID: <497A9C1B.7080002@lwfinger.net>
Date: Fri, 23 Jan 2009 22:42:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: v2.6.29-rc2 gets HSM violations for CD drive
References: <497A5836.2070904@lwfinger.net> <18810.24721.900344.239817@harpo.it.uu.se>
In-Reply-To: <18810.24721.900344.239817@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> 
> pata_ali is one of the drivers that got converted to doing 32-bit PIO.
> Please try this <http://marc.info/?l=linux-kernel&m=123254501314058&w=2>
> patch. It's known to fix similar problems seen with ata_piix.
> 

The patch fixed my problem.  Thanks,

Larry

