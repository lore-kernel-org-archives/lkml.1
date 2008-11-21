Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYKUMov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYKUMov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 07:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbYKUMom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 07:44:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51298 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbYKUMol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 07:44:41 -0500
Date: Fri, 21 Nov 2008 13:44:32 +0100
From: Karel Zak <kzak@redhat.com>
To: hooanon05@yahoo.co.jp
Cc: Andrew Morton <akpm@linux-foundation.org>, tomas@slax.org,
       linux-kernel@vger.kernel.org, akinobu.mita@gmail.com,
       util-linux-ng@vger.kernel.org
Subject: Re: [PATCH] loop file resizable
Message-ID: <20081121124432.GL2961@nb.net.home>
References: <492120DC.1070407@slax.org> <20081118164207.137e92be.akpm@linux-foundation.org> <16149.1227066661@jrobl> <20081120132654.4c649eb0.akpm@linux-foundation.org> <20081121101209.GJ2961@nb.net.home> <7554.1227270228@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7554.1227270228@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 09:23:48PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Karel Zak:
> >  It shouldn't be a problem to extend the current losetup(8). I have no
> >  problem with this change.
> 
> If you tell me the URL of the base version of losetup, I will make a
> patch.

 git://git.kernel.org/pub/scm/utils/util-linux-ng/util-linux-ng.git

 Note, that I'll commit the patch when the kernel side will be in
 Linus's tree.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
