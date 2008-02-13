Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbYBMOYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbYBMOYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYBMOYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:24:36 -0500
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:52829 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYBMOYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:24:36 -0500
Date: Wed, 13 Feb 2008 09:24:32 -0500
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/coda: remove static inline forward declarations
Message-ID: <20080213142432.GN11665@cs.cmu.edu>
Mail-Followup-To: Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0802131417460.31652@kivilampi-30.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802131417460.31652@kivilampi-30.cs.helsinki.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 02:22:43PM +0200, Ilpo J?rvinen wrote:
> They're defined later on in the same file with bodies and
> nothingin between needs them.
> 
> Signed-off-by: Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>
Acked-by: Jan Harkes <jaharkes@cs.cmu.edu>

Looks good, getting rid of such cruft is always useful.

Jan

