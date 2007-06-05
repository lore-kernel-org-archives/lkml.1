Return-Path: <linux-kernel-owner+w=401wt.eu-S1764759AbXFEOMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764759AbXFEOMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760024AbXFEOLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:11:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44481 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbXFEOLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:11:53 -0400
Date: Tue, 5 Jun 2007 16:12:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kbuild-devel] [PATCH 08/19] scripts: Make cleanfile/cleanpatch warn about long lines
Message-ID: <20070605141254.GA24722@uranus.ravnborg.org>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org> <20070605133834.GO7266@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605133834.GO7266@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 03:38:34PM +0200, Oleg Verych wrote:
> On Tue, Jun 05, 2007 at 10:19:59AM +0200, Sam Ravnborg wrote:
> []
> > If on the other hand you are proposing a script to clean whitespace
> > damage in the code then git already does this nicely.
> 
> I've read that too quickly, sorry. What then all that clean scripts
> are for?
cleanfile compress spaces to tabs where appropriate. It does more
than just warn about too long lines and remove leading whitespace.

Please look at latest -git tree if you are trying to improve
the clean* scripts or add counterparts.

Thanks,
	Sam
