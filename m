Return-Path: <linux-kernel-owner+w=401wt.eu-S1763016AbZFPUwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763016AbZFPUwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbZFPUwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:52:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756528AbZFPUwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:52:33 -0400
Date: Tue, 16 Jun 2009 13:52:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Ryan Hope <rmh3093@gmail.com>, Greg KH <greg@kroah.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm - fixes + radeon KMS (part 2)
In-Reply-To: <21d7e9970906161345q6e826d18q3a197643e370156c@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906161351130.16802@localhost.localdomain>
References: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie>  <20090615022235.GA12905@kroah.com>  <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com>  <48f7fe350906160853m41f43fe5i892a4057b5eae319@mail.gmail.com> 
 <alpine.LFD.2.01.0906161119500.3282@localhost.localdomain> <21d7e9970906161345q6e826d18q3a197643e370156c@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Dave Airlie wrote:
> 
> Linus can you pull this tree?

I hate pulling trees when I know there are _known_ bugs. 

Even during the merge window. The rest of the -rc series is for fixing up 
bugs, yes, but not bugs that were introduced on purpose.

		Linus
