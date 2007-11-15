Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbXKOOoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbXKOOoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 09:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbXKOOoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 09:44:24 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:50313 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbXKOOoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 09:44:23 -0500
Message-ID: <23908.62.180.231.196.1195137856.squirrel@housecafe.dyndns.org>
In-Reply-To: <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org>
    <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org>
    <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de>
    <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
Date: Thu, 15 Nov 2007 15:44:16 +0100 (CET)
Subject: Re: 2.6.24-rc2 XFS nfsd hang / smbd too
From: "Christian Kujau" <lists@nerdbynature.de>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Benny Halevy" <bhalevy@panasas.com>, "Chris Wedgwood" <cw@f00f.org>,
       linux-xfs@oss.sgi.com
User-Agent: SquirrelMail/1.5.2 [SVN]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, November 15, 2007 08:51, Christian Kujau wrote:
> Since NFS was not working (the nfsd processes were already in D state),
> to mount a CIFS share from the very same server (and the same client).

That should read:

Since NFS was not working (the nfsd processes were already in D state), I
decided to mount a CIFS share from the very same server (and the same
client). [...]

C.
-- 
BOFH excuse #442:

Trojan horse ran out of hay

