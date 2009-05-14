Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZENN4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZENN4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZENN4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:56:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42307 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbZENN4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:56:13 -0400
Date: Thu, 14 May 2009 16:01:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090514140138.GB10933@one.firstfloor.org>
References: <200904301408.09370.tobias.doerffel@gmail.com> <877i0xib7d.fsf@basil.nowhere.org> <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com> <20090512150408.GH19296@one.firstfloor.org> <a36005b50905121045s62c16760p3aba003647a572c7@mail.gmail.com> <1242277453.23058.35.camel@brick> <a36005b50905140638r56f73095kfc669bae1333e2bd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50905140638r56f73095kfc669bae1333e2bd@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 06:38:48AM -0700, Ulrich Drepper wrote:
> On Wed, May 13, 2009 at 10:04 PM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
> > It's called be16_to_cpup, or on x86, swab16p()
> 
> Indeed.  If now somebody with an Atom could test whether using movbe
> has an advantage (my guess is that there is a slight advantage) then

How would you test that?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
