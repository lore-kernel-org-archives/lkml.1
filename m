Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbZCJQ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbZCJQ6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZCJQ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:58:29 -0400
Received: from dtp.xs4all.nl ([80.101.171.8]:50565 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752971AbZCJQ62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:58:28 -0400
Date: Tue, 10 Mar 2009 17:58:24 +0100
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Scott James Remnant <scott@canonical.com>
Cc: linux-kernel@vger.kernel.org, R.E.Wolff@BitWizard.nl
Subject: Re: [PATCH 20/31] specialix: Auto-load specialix module when device opened.
Message-ID: <20090310165824.GB7658@bitwizard.nl>
References: <cover.1236702228.git.scott@canonical.com> <fd9db053766bd9fa3d8ffa35daebc90cf25df6cd.1236702228.git.scott@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd9db053766bd9fa3d8ffa35daebc90cf25df6cd.1236702228.git.scott@canonical.com>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 06:39:40PM +0000, Scott James Remnant wrote:
> The specialix module is missing the char-major-75-* alias that would
> cause it to be auto-loaded when a device of that type is opened.  This
> patch adds the alias.
> 
> Signed-off-by: Scott James Remnant <scott@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Roger Wolff <R.E.Wolff@BitWizard.nl>

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
**    Delftechpark 26 2628 XH  Delft, The Netherlands. KVK: 27239233    **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
