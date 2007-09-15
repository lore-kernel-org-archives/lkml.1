Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbXIOFRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbXIOFRE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 01:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbXIOFQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 01:16:56 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53627 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXIOFQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 01:16:55 -0400
Date: Sat, 15 Sep 2007 07:18:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Wilder <dwilder@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, SystemTAP <systemtap@sources.redhat.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] Trace code and documentation
Message-ID: <20070915051820.GA8344@uranus.ravnborg.org>
References: <46E9CB14.7060000@us.ibm.com> <20070914175027.GA3642@uranus.ravnborg.org> <46EB645B.6000302@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EB645B.6000302@us.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 09:49:31PM -0700, David Wilder wrote:
> Sam Ravnborg wrote:
> >Hi David.
> >
> >A random comment to the code.
> >Several of the struct file_operations are not declared static as
> >they should be.
> >
> >Btw. it looks good from a coding style point-of-view.
> >
> >About the name what about ktrace??
> >
> >	Sam
> >
> >  
> Thanks for the comment. I sure don't want to change the name a forth 
> time, can we live with "trace"?

I do not care much about the name so no big deal for me.
I was just soo generic..

	Sam
