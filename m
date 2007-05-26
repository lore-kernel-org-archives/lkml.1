Return-Path: <linux-kernel-owner+w=401wt.eu-S1763946AbXEZSlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763946AbXEZSlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 14:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762927AbXEZSl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 14:41:26 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:42613 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762931AbXEZSlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 14:41:24 -0400
Date: Sat, 26 May 2007 14:41:22 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Crispin Cowan <crispin@novell.com>
cc: casey@schaufler-ca.com, Andreas Gruenbacher <agruen@suse.de>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM
 hook
In-Reply-To: <4657C547.6030506@novell.com>
Message-ID: <Line.LNX.4.64.0705261439590.23020@d.namei>
References: <312681.33492.qm@web36609.mail.mud.yahoo.com> <4657C547.6030506@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Crispin Cowan wrote:

> Finally, AA doesn't care what the contents of the executable are. We
> assume that it is a copy of metasploit or something, and confine it to
> access only the resources that the policy says.

As long as these resources are only files.  There is no confinement beyond 
that.


- James
-- 
James Morris
<jmorris@namei.org>
