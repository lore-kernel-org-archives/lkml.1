Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYG3Grb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYG3Grb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 02:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbYG3GrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 02:47:23 -0400
Received: from isilmar.linta.de ([213.133.102.198]:50300 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751233AbYG3GrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 02:47:23 -0400
Date: Wed, 30 Jul 2008 08:47:20 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 4/5] docsrc: fix crc32hash type
Message-ID: <20080730064720.GA13409@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Sam Ravnborg <sam@ravnborg.org>
References: <12173619152424@xenotime.net> <1217361915584@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217361915584@xenotime.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 29, 2008 at 01:05:15PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix differing signedness warning:
> 
> Documentation/pcmcia/crc32hash.c:29: warning: pointer targets in passing argument 1 of 'crc32' differ in signedness
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>

Shall this go in via the pcmcia git tree, or with the other doc patches?

Best,
	Dominik
