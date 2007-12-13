Return-Path: <linux-kernel-owner+w=401wt.eu-S1762460AbXLMPHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762460AbXLMPHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 10:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761817AbXLMPGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 10:06:40 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:47612 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437AbXLMPG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 10:06:28 -0500
Date: Thu, 13 Dec 2007 10:06:03 -0500
Message-Id: <200712131506.lBDF633t032100@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, hch@infradead.org, viro@ftp.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/42] Unionfs: filesystems documentation index 
In-reply-to: Your message of "Mon, 10 Dec 2007 15:47:50 +0100."
             <Pine.LNX.4.64.0712101546460.25446@fbirervta.pbzchgretzou.qr> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <Pine.LNX.4.64.0712101546460.25446@fbirervta.pbzchgretzou.qr>, Jan Engelhardt writes:
> 
> On Dec 9 2007 21:41, Erez Zadok wrote:
> >
> >Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> >---
> > Documentation/filesystems/00-INDEX |    2 ++
> > 1 files changed, 2 insertions(+), 0 deletions(-)
> >
> 
> This is not CVS, you are allowed to have multiple files in a changeset :-)
> Perhaps fold 1-7.

Agreed.  I've merged the documentation patches together, as well as several other
related ones (esp. small ones); this also helps for bisecting.

Erez.
