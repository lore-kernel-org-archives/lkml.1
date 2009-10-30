Return-Path: <linux-kernel-owner+w=401wt.eu-S1756972AbZJ3CTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbZJ3CTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 22:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756437AbZJ3CTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 22:19:07 -0400
Received: from icculus.org ([67.106.77.212]:54761 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbZJ3CTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 22:19:06 -0400
Date: Thu, 29 Oct 2009 22:19:05 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@andre.icculuslan
To: linux-kernel@vger.kernel.org
Subject: FatELF patches...
Message-ID: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Having heard a bunch of commentary, and made a bunch of changes based on 
some really good feedback, here are my hopefully-final FatELF patches. I'm 
pretty happy with the final results. The only changes over the last 
posting is that I cleaned up all the checkpatch.pl complaints (whitespace 
etc).

What's the best way to get this moving towards the mainline? It's not 
clear to me who the binfmt_elf maintainer would be. Is this something that 
should go to Andrew Morton for the -mm tree?

--ryan.

