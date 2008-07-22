Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYGVMab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYGVMab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 08:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYGVMaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 08:30:23 -0400
Received: from main.gmane.org ([80.91.229.2]:55430 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbYGVMaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 08:30:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el es <el_es_cr@yahoo.co.uk>
Subject: Re: Kernel version : what about s.yy.ww.tt scheme ?
Date: Tue, 22 Jul 2008 12:30:13 +0000 (UTC)
Message-ID: <loom.20080722T120836-981@post.gmane.org>
References: <loom.20080717T083755-676@post.gmane.org> <alpine.LNX.1.10.0807171140030.18697@fbirervta.pbzchgretzou.qr> <20080720181426.GA29189@1wt.eu> <loom.20080721T074322-56@post.gmane.org> <alpine.DEB.1.10.0807210216260.1125@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.151.128.130 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.16) Gecko/20080702 Firefox/2.0.0.16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 <david <at> lang.hm> writes:


> you are well past the point where the complexity overwelmes the 
> information you are providing.
> 
> does it really matter _exactly_ when a release was made?
> 
> David Lang
> 
It might not really matter, but if you could find a reason for it to be useful,
then why not ?

As I wrote before, the development of the kernel is currently quite fast-paced.
The scale of changes is not that dramatic as it was in the early days, is it ?
Of course things get added, removed and so on. You even get lots of development
trees tested in linux-next on a daily basis. With date-based version number, you
can exactly position your own tree in time related to the current development.
It is more human-readable. The version number as it is, just does not entirely
fit the current model of development IMO - with 2 week merge window and roughly
2 months of stabilization period, the counter becomes sort of uninformative... 
But for the releases, the week-based granularity seems to be enough - the
current habit of having a stable by number is actually OK too, since the -stable
team does its job. So, yes, to have a similar version number to what is used
currently, the scheme could be s.yy.ww.[nn || -rcX], s=series (2), yy= year,
ww=week when the tree was released, nn= stable number. What do you think ?


