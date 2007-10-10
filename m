Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXJJKuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXJJKuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 06:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXJJKuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 06:50:13 -0400
Received: from archer.toppoint.de ([217.70.197.1]:59372 "EHLO mail.toppoint.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbXJJKuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 06:50:12 -0400
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2007 06:50:10 EDT
Date: Wed, 10 Oct 2007 12:23:32 +0200
From: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: build error
Message-ID: <20071010102332.GA17932@kaos.in-kiel.de>
References: <20071002201213.GA5605@chaos.in-kiel.de> <20071002171942.047450fe@freepuppy.rosehill> <20071002172827.b2f51626.randy.dunlap@oracle.com> <20071002173921.4710a74b@oldman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002173921.4710a74b@oldman>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 05:39:21PM -0700 Stephen Hemminger wrote:
> There were earlier reports of gcc 4.3 bogus optimization:
>   http://lkml.org/lkml/2007/5/18/355

Indeed, it compiled cleanly with gcc 4.2.

Thanks. This won't happen again.

Wilfried
-- 
Irgendwas ist ja immer...
