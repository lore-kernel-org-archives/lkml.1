Return-Path: <linux-kernel-owner+w=401wt.eu-S1762815AbZATBrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815AbZATBrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbZATBrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:47:11 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:47883 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbZATBrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:47:10 -0500
Date: Tue, 20 Jan 2009 02:45:07 +0100
From: Arjan Opmeer <arjan@opmeer.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alexander E. Patrakov" <patrakov@gmail.com>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Message-ID: <20090120014507.GA1557@adopmeer.homeip.net>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.HKC.vJRdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cX2gZ6Cy9nC.A.HKC.vJRdJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [Bug #12406] 2.6.28 thinks that my PS/2 mouse is a touchpad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, Jan 19, 2009 at 10:45:42PM +0100, Rafael J. Wysocki wrote:
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).

Well. Dmitry hasn't replied yet to my suggestion how to fix this as
presented in the Patch entry. Without help from him as the Linux input
subsystem maintainer there is not a lot I can do.

This means the regression is still present in the current 2.6.29 git tree.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12406
> Subject	: 2.6.28 thinks that my PS/2 mouse is a touchpad
> Submitter	: Alexander E. Patrakov <patrakov@gmail.com>
> Date		: 2008-12-27 9:06 (24 days old)
> References	: http://marc.info/?l=linux-kernel&m=123036893817280&w=4
> Handled-By	: Arjan Opmeer <arjan@opmeer.net>
> Patch		: http://marc.info/?l=linux-kernel&m=123092147703236&w=4


Arjan
