Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZBTNcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZBTNcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZBTNbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:31:51 -0500
Received: from tundra.namei.org ([65.99.196.166]:2895 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbZBTNbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:31:50 -0500
Date: Sat, 21 Feb 2009 00:31:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
       David Safford <safford@watson.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH] integrity: ima scatterlist bug fix
In-Reply-To: <a4423d670902200251l6087d8afu88409bf4e2e6cb4e@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0902210031330.9330@tundra.namei.org>
References: <1235096630-3099-1-git-send-email-zohar@linux.vnet.ibm.com> <a4423d670902200251l6087d8afu88409bf4e2e6cb4e@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009, Alexander Beregalov wrote:

> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Tested-by: Alexander Beregalov <a.beregalov@gmail.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
