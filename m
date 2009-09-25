Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZIYAYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZIYAYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZIYAYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:24:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:37158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbZIYAYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:24:37 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] vfs: new O_NODE open flag
Date: Fri, 25 Sep 2009 02:23:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu>
In-Reply-To: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909250223.58664.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 24 September 2009 16:51:58 Miklos Szeredi wrote:
> This patch adds a new open flag, O_NODE.  This flag means: open just
> the filesystem node instead of the object referenced by the node.

What is the intended use for O_NODE?

Thanks,
Andreas
