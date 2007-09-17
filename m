Return-Path: <linux-kernel-owner+w=401wt.eu-S1758542AbXIRAFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542AbXIRAFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 20:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXIRAFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 20:05:08 -0400
Received: from pool-71-118-246-34.lsanca.dsl-w.verizon.net ([71.118.246.34]:45958
	"EHLO www.thewybles.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbXIRAFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 20:05:06 -0400
X-Greylist: delayed 2103 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2007 20:05:06 EDT
Message-ID: <46EF0E0A.2000804@thewybles.com>
Date: Mon, 17 Sep 2007 16:30:18 -0700
From: Charles N Wyble <charles@thewybles.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 2/3] Consolidate host virtualization support	under	Virtualization
 menu
References: <1189747054.7262.34.camel@localhost.localdomain>	<1189747124.7262.36.camel@localhost.localdomain>	<20070914091921.73007c5a.randy.dunlap@oracle.com>	<1189825504.7262.75.camel@localhost.localdomain>	<7fac565a0709150149kf55de62q92496cf74e7b0581@mail.gmail.com>	<1189928617.7262.98.camel@localhost.localdomain>	<46ED440E.3020209@goop.org> <1190057480.5982.157.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1190057480.5982.157.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1



Zachary Amsden wrote:
<snip>>
> Virtualization is completely different, and probably needs separate
> server (kvm, lguest) and client (kvm, lguest, xen, vmware) sections in
> it's menu.


So what is the differentiation between client and server above? Just
curious what makes kvm and lguest server and client.

>
> Zach
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/virtualization
>
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG7w3ckQPZV56XDBMRAvvaAJ9cHl+A321MJyw6W4J4yIDurz0K2wCcDg8J
uOR6alAGvWjxEbThiuaeIDc=
=TQ3m
-----END PGP SIGNATURE-----
