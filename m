Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYLVOXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYLVOXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 09:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYLVOXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 09:23:07 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51998 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754468AbYLVOXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 09:23:05 -0500
X-Sasl-enc: N0WaTIQrZj3B/mR3JcNhmxUjSaYtAGyt9x8qN8L4qSmE 1229955782
Subject: Re: [rfc git patch] union directory
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, jblunck@suse.de, dlezcano@fr.ibm.com,
       linux-kernel@vger.kernel.org, bharata@linux.vnet.ibm.com,
       viro@ZenIV.linux.org.uk, vaurora@redhat.com
In-Reply-To: <E1LElCn-0005gp-G1@pomaz-ex.szeredi.hu>
References: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu>
	 <alpine.LFD.2.00.0812171350350.11591@zeus.themaw.net>
	 <E1LDLzo-0007oD-Lg@pomaz-ex.szeredi.hu>
	 <1229651242.3026.39.camel@zeus.themaw.net>
	 <E1LElCn-0005gp-G1@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 23:22:59 +0900
Message-Id: <1229955779.3040.2.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-22 at 14:52 +0100, Miklos Szeredi wrote:
> 
> > Valerie Henson is planning to start a project (when she is done with
> > current commitments) along the lines of a lightweight stacking layer
> > with union support included in the file system. These continuing
> > individual efforts are a little disjoint so such a project could be an
> > ideal way to define what's needed, what the issues are and how it will
> > be done in one place. Hopefully everyone that is keen to see progress in
> > this area will want to be involved too, ;)
> 
> Interesting.
> 
> It maybe worth mentioning here that fuse is also a very capable
> "stacking layer" and with planned performance improvements it might
> become the best option to implement such fs stacks.

Yes, also an interesting thought.

How would you see fuse fitting into the overall solution of this problem
(aka what bits would live in the VFS and what bits would fuse address)?

Ian


