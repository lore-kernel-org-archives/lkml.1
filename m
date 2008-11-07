Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbYKGXBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbYKGXBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYKGXBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:01:18 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:34721 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYKGXBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:01:17 -0500
Message-ID: <4914C8AA.1080204@kernel.org>
Date: Fri, 07 Nov 2008 15:00:58 -0800
From: "J.H." <warthog9@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: users@linux.kernel.org, git@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, ftpadmin@kernel.org
Subject: Re: [KORG] Master backend downtime - hardware swap
References: <49139D4C.2010004@kernel.org>
In-Reply-To: <49139D4C.2010004@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.1.12 (shards.monkeyblade.net [198.137.202.13]); Fri, 07 Nov 2008 15:00:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Just a heads up to everyone, ran slightly over (rsync took longer to
verify the move than I expected).  But we are moved over to the much
bigger and faster new master.kernel.org server.

For those curious it's a:
HP DL380 G5
	2 x Intel Quad Core Xeon's
	16G ram
	Pile more disk (including an external MSA chassis)

Thanks go out to HP for the new hardware, and their continued support of
Kernel.org!!!

If there are problems, issues or concerns please report them to
ftpadmin@kernel.org, a quick look around seems to indicate everything
looks good however.

- - John 'Warthog9' Hawley
Chief Kernel.org Administrator

J.H. wrote:
> Hey everyone,
> 
> Just a heads up to everyone, I'm going to be taking the master (hera)
> backend server offline for a couple of hours tomorrow (Friday, CST)
> afternoon.  Downtime is going to get used for finishing flipping over
> the master to new hardware, which was very generously donated by
> Hewlett-Packard.  We are moving up to a new DL380 G5.  That said I will
> need time to shut everything down, get a current rsync from the old
> hardware to the new hardware and confirm that serves are restored on the
> new machine.
> 
> I'm expecting the entire downtime to only take a couple of hours, but
> since we all know things will take longer I'm going to declare the
> window from 1200 CST (1800 UTC Friday Nov 7th).  Expect the window to
> run through 2000 UTC, and if things are up and running before that I'll
> let people know.  Otherwise if there are problems you'll see another
> e-mail from me.
> 
> If you have questions, comments, concerns, etc - please send them to me
> CC ftpadmin@kernel.org
> 
> - John 'Warthog9' Hawley
> Chief Kernel.org Administrator
- --
To unsubscribe from this list: send the line "unsubscribe git" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFJFMip/E3kyWU9dicRAv4aAJ4l6dSodeAT6eGx9sb0wpsv44KY0gCePJsD
gNdijp6x/oEHXwkxkbqxWB8=
=CWoY
-----END PGP SIGNATURE-----
