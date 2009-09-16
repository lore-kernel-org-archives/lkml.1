Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbZIPB2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbZIPB2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 21:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZIPB2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 21:28:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:57737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZIPB2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 21:28:07 -0400
Message-ID: <4AB03F23.7080605@kernel.org>
Date: Wed, 16 Sep 2009 10:28:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [GIT PULL] percpu for v2.6.32
References: <4AAF411C.2040501@kernel.org> <alpine.DEB.1.10.0909151510010.3340@V090114053VZO-1> <4AAFE9B2.1030006@kernel.org> <alpine.DEB.1.10.0909151531490.3340@V090114053VZO-1> <4AAFEF48.8000607@sgi.com>
In-Reply-To: <4AAFEF48.8000607@sgi.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 01:28:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mike Travis wrote:
> We certainly have some in our labs but I'm not sure of one that's
> externally accessible.  If there's a pre-defined test you'd like to
> run, you can send me the details.  Otherwise, I'll check around and
> see if there's a system available remotely.

The proposed broken patch is in the following thread.  It works on ski
emulator but ski doesn't support SMP, so...

 http://thread.gmane.org/gmane.linux.kernel.cross-arch/4132

The patch shouldn't be too broken.  It probably needs slight tweaks
here and there.  Just testing and providing logs would be helpful
enough.

Thanks.

-- 
tejun
