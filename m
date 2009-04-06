Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZDFXXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZDFXXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 19:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZDFXXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 19:23:20 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:55988 "EHLO
	bunyip.billabong.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751787AbZDFXXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 19:23:19 -0400
X-Greylist: delayed 2122 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Apr 2009 19:23:19 EDT
Date: Tue, 7 Apr 2009 08:47:49 +1000
From: CaT <cat@zip.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12909] boot/kernel init duration regression from 2.6.28
Message-ID: <20090406224749.GC19377@zip.com.au>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <AsKNxFx2juN.A.z3H.SGn2JB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AsKNxFx2juN.A.z3H.SGn2JB@chimera>
Organisation: Furball Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 09:05:41PM +0200, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12909
> Subject		: boot/kernel init duration regression from 2.6.28
> Submitter	: CaT <cat@zip.com.au>
> Date		: 2009-03-16 10:25 (22 days old)
> References	: http://marc.info/?l=linux-kernel&m=123720083515950&w=4

I got it tracked down to .29-rc1. I guess I'll need to learn to use git
now (and user the desktop - compiling on the EEE takes /ages/). Also have
.29.1 ready to test when I get home tonight.

-- 
  "A search of his car uncovered pornography, a homemade sex aid, women's 
  stockings and a Jack Russell terrier."
    - http://www.news.com.au/story/0%2C27574%2C24675808-421%2C00.html
