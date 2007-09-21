Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbXIUGfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbXIUGfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 02:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbXIUGfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 02:35:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:48409 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbXIUGfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 02:35:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VNTafJRbv4qDKiIXf6PIQXKaAleBcyhgtesumBYut1CNpRlbJ1ygyuRCHX/JwDPMoLcuam/btMrWAinWmrb6pqmuDcm6bivZE9tPJrR66/o1/oVNqNOp29+YKuxiEP0sqZ+68Va0AHRI+ADm5wogn6pyoaSWTR6z3ZWjEl9mjJQ=
Message-ID: <46d6db660709202335w7fc75be7k72a2e9689e9b3205@mail.gmail.com>
Date: Fri, 21 Sep 2007 08:35:01 +0200
From: "Christian MICHON" <christian.michon@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: Monster switch for small size (was Linux-tiny revival)
Cc: linux-tiny@selenic.com, "Michael Opdenacker" <michael@free-electrons.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "Andy Whitcroft" <apw@shadowen.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200709201641.22580.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46F1645D.9050406@am.sony.com> <20070920091042.GA6035@shadowen.org>
	 <46F2A99A.3080400@am.sony.com> <200709201641.22580.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/20/07, Rob Landley <rob@landley.net> wrote:
> (I cut the bit where you reinvent miniconfig.  People keep doing this.  I dig
> it up and resubmit it every year or so, so Roman Zippel can shoot it down
> again.  Meanwhile, not only is Firmware Linux happily using it, but I even
> wrote more documentation at
> http://landley.net/code/firmware/new_platform.html although you have to
> scroll down a bit to get to the stuff about miniconfig...)

DetaolB (see signature) is also using miniconfig, which is good
existing code. It can actually be pushed further by storing a
/proc/miniconfig.gz rather than the full /proc/config.gz

You can find patches on how to perform this inside the iso of DetaolB v0.6

-- 
Christian
--
http://detaolb.sourceforge.net/, a linux distribution for Qemu with Git inside !
