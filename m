Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbYJPJeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbYJPJeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbYJPJeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:34:01 -0400
Received: from main.gmane.org ([80.91.229.2]:53888 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbYJPJeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:34:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Thu, 16 Oct 2008 09:33:50 +0000 (UTC)
Message-ID: <loom.20081016T092338-594@post.gmane.org>
References: <20081016002509.GA25868@kroah.com> <loom.20081016T075618-911@post.gmane.org> <48F704E6.2010409@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 86.166.207.29 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.3) Gecko/2008092417 Firefox/3.0.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa <at> zytor.com> writes:

> 
> el es wrote:
[snip]
> > - informative : the ww and tt numbers are the week numbers of when the actual
> > 
> > release HAPPENED, not when it is predicted.
> > 
> 
> Which really sucks for dealing with future releases.
> 

Why ? 
What do you mean by 'future releases' ? 
Can you predict exactly when the next release will happen ? The current practice 
of -rcX shows clearly you cannot. 

Moreover, with my idea you could easily say, which stable release is still
supported (and how old its mainline really was) up to the week, which IMHO is
granular enough.
Also you could for sure say, that e.g. a device/software that hit market in say 
December this year, will be compatible with e.g. 2.09.XX+ - look at users POV. 

Current scheme is great, established and understandable, but sucks at this 
point : for any product, be it hardware or software, you need to print both its 
date of creation AND the minimum kernel that supports it. With my idea, it is 
only the date you need. 

> 	-hpa
> 

Lukasz


