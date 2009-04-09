Return-Path: <linux-kernel-owner+w=401wt.eu-S1765957AbZDIOhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765957AbZDIOhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbZDIOhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:37:01 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38326 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbZDIOhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:37:01 -0400
Date: Thu, 9 Apr 2009 16:39:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: James Morris <jmorris@namei.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: WARNING at linux/security.h:1889 expand_downwards
Message-ID: <20090409143924.GJ14687@one.firstfloor.org>
References: <20090409102416.GA21280@basil.nowhere.org> <alpine.LRH.2.00.0904100022140.16073@tundra.namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0904100022140.16073@tundra.namei.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 12:24:30AM +1000, James Morris wrote:
> > Freeing unused kernel memory: 600k freed
> > ------------[ cut here ]------------
> > WARNING: at /home/ak/lsrc/newmce/linux/include/linux/security.h:1889 expand_downwards+0xee/0x179()
> > Hardware name: MS-7383
> 
> Are you running in a virtual machine?

Nope, it's a real box, but running NFS root.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
