Return-Path: <linux-kernel-owner+w=401wt.eu-S932350AbZLDRjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbZLDRjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbZLDRjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:39:08 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55068 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbZLDRjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:39:07 -0500
Date: Fri, 4 Dec 2009 12:39:02 -0500
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>,
       Paul Mackerras <paulus@samba.org>, Jean Delvare <khali@linux-fr.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] MAINTAINERS: Add PowerPC patterns
Message-ID: <20091204173902.GK2937@zod.rchland.ibm.com>
References: <20091202091951.5ec6bb83@hyperion.delvare> <1259894454.2076.1246.camel@pasglop> <20091204103434.0a754925@hyperion.delvare> <1259920775.2076.1273.camel@pasglop> <1259947019.22783.116.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259947019.22783.116.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 09:16:59AM -0800, Joe Perches wrote:
> LINUX FOR POWERPC EMBEDDED PPC4XX
> M:	Josh Boyer <jwboyer@linux.vnet.ibm.com>
>@@ -3221,6 +3228,8 @@ W:	http://www.penguinppc.org/
> L:	linuxppc-dev@ozlabs.org
> T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jwboyer/powerpc-4xx.git
> S:	Maintained
>+F:	arch/powerpc/platforms/40x/
>+F:	arch/powerpc/platforms/44x/

This is mostly complete.  There are a few files under arch/powerpc/sysdev/, and
arch/powerpc/boot/ as well, but I don't think they're entirely necessary.

For the 4xx parts:

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

josh
