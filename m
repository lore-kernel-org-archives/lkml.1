Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbXF0NPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbXF0NPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbXF0NPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:15:25 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33576 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881AbXF0NPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:15:24 -0400
Date: Wed, 27 Jun 2007 06:12:34 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Hawk Xu <hxunix@gmail.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       jmorris@namei.org, serue@us.ibm.com, chrisw@sous-sol.org,
       sds@tycho.nsa.gov, greg@kroah.com, eparis@redhat.com
Subject: Re: [PATCH] [RFC] security: add hook inode_post_removexattr
Message-ID: <20070627131234.GX3723@sequoia.sous-sol.org>
References: <46825D77.4050608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46825D77.4050608@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Hawk Xu (hxunix@gmail.com) wrote:
> Add hook inode_post_removexattr for updating inode security field after 
> successful removexattr operation.

That is an insufficient explanation of why it's needed, who is using it,
etc.

thanks,
-chris
