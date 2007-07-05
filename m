Return-Path: <linux-kernel-owner+w=401wt.eu-S1761683AbXGEN2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761683AbXGEN2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 09:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761574AbXGEN2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 09:28:35 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:35299 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761558AbXGEN2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 09:28:34 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 15:28:33 +0200
User-Agent: KMail/1.9.7
Cc: Miklos Szeredi <miklos@szeredi.hu>, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <E1I6Pud-0000V1-00@dorka.pomaz.szeredi.hu> <200707051523.44826.rjw@sisk.pl>
In-Reply-To: <200707051523.44826.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707051528.34754.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 5. Juli 2007 schrieb Rafael J. Wysocki:
> > It seems pretty clear cut.  Whining about how much problems this will
> > cause won't get us nearer to a solution.
> 
> Yes, that's pretty clear cut, but we should start from fixing the drivers. :-)

If, at a minimum, we can determine that we can STD without a freezer.
It makes no sense to invest a lot of work to face the same problem
again with STD.

	Regards
		Oliver

