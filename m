Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYJPKF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYJPKF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYJPKFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:05:48 -0400
Received: from main.gmane.org ([80.91.229.2]:40299 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbYJPKFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:05:48 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: [RFC] Kernel version numbering scheme change
Date: Thu, 16 Oct 2008 10:05:32 +0000 (UTC)
Message-ID: <loom.20081016T094113-612@post.gmane.org>
References: <20081016002509.GA25868@kroah.com> <loom.20081016T075618-911@post.gmane.org> <48F704E6.2010409@zytor.com> <loom.20081016T092338-594@post.gmane.org>
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

el es <el_es_cr <at> yahoo.co.uk> writes:

> 
> H. Peter Anvin <hpa <at> zytor.com> writes:
> 
> > 
> > el es wrote:
> [snip]
> > > - informative : the ww and tt numbers are the week numbers of when the 
> > > actual release HAPPENED, not when it is predicted.

> > Which really sucks for dealing with future releases.
> > 
> 
> Why ? 
> What do you mean by 'future releases' ? 

Oh, I just read your suggestion to move on with 3, 4 and so on. To keep it 
simple.

How about adopting your scheme (simple counter) with mine (yy.ww.tt) ?

Speaking on my own, I think that some indication of WHEN the release actually
happened, encoded in the version number, IS desirable. I'm not a developer (my
field is far, far away) but personally I find the suggestions to put full year
figure in front, grossly disturbing everything we accustomed to ;)

OR.
If in my idea, we drop the .tt bit, hence, we declare, that the stable team just
continues the work on the released version, like

- 2.08.41 is the currently released 2.6.27,
- developers continue on 2.08.41-rcX, which gets promoted to 3.yy.ww when 
released and so on,
- meanwhile the stable team releases 2.08.[42..52], 2.09.[01..52] and so on. 

Being an indication of continuity.
As well as a revolution too ;)
> > 
> 
> Lukasz
> 
> 




