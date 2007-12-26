Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbXLZHeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbXLZHeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 02:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXLZHel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 02:34:41 -0500
Received: from namei.org ([69.55.235.186]:59809 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751307AbXLZHek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 02:34:40 -0500
Date: Wed, 26 Dec 2007 18:34:26 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul.moore@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
In-Reply-To: <30638.1198647786@turing-police.cc.vt.edu>
Message-ID: <Xine.LNX.4.64.0712261833110.7815@us.intercode.com.au>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
 <30638.1198647786@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2007, Valdis.Kletnieks@vt.edu wrote:

> I already checked, it's not a slam-dunk to just 'patch -R' as there's 3 or 4
> conflicts where later patches need massaging/reverting as well.
> 
> It's a problem with both 'classic RCU' and 'preempt RCU' (that was my *first*
> guess as to the cause).
> 
> Any clues/hints/advice/patches?

Can you post your .config ?

Also, is that the plain upstream Tcl package you're compiling, or a distro 
package?

-- 
James Morris
<jmorris@namei.org>
