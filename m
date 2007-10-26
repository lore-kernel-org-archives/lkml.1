Return-Path: <linux-kernel-owner+w=401wt.eu-S1764791AbXJZW1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764791AbXJZW1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbXJZW1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:27:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46239 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbXJZW1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:27:14 -0400
Date: Fri, 26 Oct 2007 15:23:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 00/45] AppArmor security module overview
Message-ID: <20071026152321.61e12041@laptopd505.fenrus.org>
In-Reply-To: <47226755.8090106@crispincowan.com>
References: <20071026064024.243943043@suse.de>
	<20071026073721.618b4778@laptopd505.fenrus.org>
	<200710262244.57147.agruen@suse.de>
	<20071026141358.38342c0f@laptopd505.fenrus.org>
	<47226755.8090106@crispincowan.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007 15:16:53 -0700
Crispin Cowan <crispin@crispincowan.com> wrote:

> 
> > On the first part (discussion of the model) I doubt we can get
> > people to agree, that's pretty much phylosophical... on the second
> > part (how well the code/design lives up to its own goals) the
> > analysis can be objective and technical.
> >   
> I will try to do that as soon as possible. While I will strive to be
> both clear and precise, achieving both is challenging. So, if someone
> discovers a mis-match between the description and the code, would a
> patch to the description be an acceptable resolution, if it did not
> render the model silly?
> 

I think it's entirely reasonable that if it turns out that the code
can't do a certain aspect of the envisioned security (eg not just a
code bug but a design level issue), the answer is to adjust the
vision...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
