Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXD2Hug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXD2Hug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbXD2Hug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:50:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:49768 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756309AbXD2Huf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=HZYC2QDKSFz2tghslI4BgNLnJQuF7yFsJo+ZC8kpyMqLd+DGD7/kHSEWDJg2/kwU6JwnAuRhSqR/F46L3+iSj1VsvBB7um02yK4dGMwISV41k8n3IA+nyBFcUh6Y1zB31Bdt/Q/G4wTtt7IF/S20fsnIX/yF8RqyuxPrzTQ37lo=
Message-ID: <46344E45.8040701@gmail.com>
Date: Sun, 29 Apr 2007 16:50:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [DOC] Fix wrong identifier name in Documentation/driver-model/devres.txt
References: <200704260926.33826.eike-kernel@sf-tec.de> <463364CF.20801@garzik.org>
In-Reply-To: <463364CF.20801@garzik.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Now that devres is in the kernel, I don't think I am the best person to
> merge these sort of patches.  Certainly I can, and I know the code from
> my original review and subsequent usage, but I think the patch is more
> appropriate for Greg, going through normal maintainership channels.
> 
> IOW, I think devres is too generic to be queued via libata-dev.git.
> 
> Tejun, comments?

I don't have problem either way.  If it's okay with Greg, I'll queue
future devres updates through Greg.

BTW, converting network drivers to devres is on my ever-growing todo
list and when those are done they will go through you, Jeff.  :-)

-- 
tejun
