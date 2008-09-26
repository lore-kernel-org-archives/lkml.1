Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbYIZEps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbYIZEps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 00:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750969AbYIZEpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 00:45:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYIZEpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 00:45:38 -0400
Date: Thu, 25 Sep 2008 21:44:24 -0700
From: Greg KH <greg@kroah.com>
To: Jing Huang <huangj@Brocade.COM>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>,
       "Srikanth Rayas (CW)" <srayas@Brocade.COM>,
       Vinodh Ravindran <vravindr@Brocade.COM>
Subject: Re: [PATCH 1/6] bfa: Brocade BFA FC SCSI driver submission (2ndtry)
Message-ID: <20080926044424.GA10662@kroah.com>
References: <200809260054.m8Q0slEL027478@swe37.brocade.com> <20080926025256.GB9480@kroah.com> <4C94DE2070B172459E4F1EE14BD2364E01F28072@HQ-EXCH-5.corp.brocade.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C94DE2070B172459E4F1EE14BD2364E01F28072@HQ-EXCH-5.corp.brocade.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 09:19:26PM -0700, Jing Huang wrote:
> Hi Greg, 
> 
> Those comments are used by doxygen. We use doxygen to generate
> documentation in my company. So I guess this contradicts to linux
> kerneldoc. I will look into this.

Yes, please fix, the kernel does not use doxygen.

thanks,

greg k-h
