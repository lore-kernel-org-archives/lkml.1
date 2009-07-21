Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbZGUQvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbZGUQvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZGUQvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:51:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbZGUQvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:51:37 -0400
Date: Tue, 21 Jul 2009 09:49:19 -0700
From: Greg KH <greg@kroah.com>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
Cc: jmorris@namei.org, sds@tycho.nsa.gov, casey@schaufler-ca.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
Message-ID: <20090721164919.GD14746@kroah.com>
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
 <1248193767.10726.21.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248193767.10726.21.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:29:27PM -0400, David P. Quigley wrote:
> Its been almost a week and I haven't heard any additional feedback on
> this patch. Are there any other complaints or should Greg take the
> patch?

Greg needs acks from Casey and others, like I stated before, before I
will take the patch.

thanks,

greg k-h
