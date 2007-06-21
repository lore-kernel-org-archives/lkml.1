Return-Path: <linux-kernel-owner+w=401wt.eu-S1757705AbXFUQBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705AbXFUQBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbXFUQBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:01:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbXFUQBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:01:35 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Greg KH <greg@kroah.com>
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Date: Thu, 21 Jun 2007 18:01:05 +0200
User-Agent: KMail/1.9.5
Cc: Crispin Cowan <crispin@novell.com>, Pavel Machek <pavel@ucw.cz>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <46732124.80509@novell.com> <20070615234925.GB15056@kroah.com>
In-Reply-To: <20070615234925.GB15056@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706211801.05834.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2007 01:49, Greg KH wrote:
> But for those types of models that do not map well to internal kernel
> structures, perhaps they should be modeled on top of a security system that
> does handle the internal kernel representation of things in the way the
> kernel works.

How exactly are struct vfsmount and struct dentry not in-kernel structures?

Andreas
