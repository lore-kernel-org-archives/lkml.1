Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbYAYKRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbYAYKRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYAYKRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:17:34 -0500
Received: from static.88-198-5-81.clients.your-server.de ([88.198.5.81]:42018
	"EHLO static.88-198-5-81.clients.your-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbYAYKRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:17:33 -0500
Message-ID: <4799B732.2030907@linuxdingsda.de>
Date: Fri, 25 Jan 2008 11:17:22 +0100
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [resolved] kernel bug report 2.6.24-rc8 on core2quad q6600 with
 debian unstable amd64
References: <4797D86B.3060202@linuxdingsda.de> <20080123170748.36068472@deepthought> <20080124144547.GB16173@csclub.uwaterloo.ca>
In-Reply-To: <20080124144547.GB16173@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Lennart Sorensen wrote:
> On Wed, Jan 23, 2008 at 05:07:48PM -0800, Stephen Hemminger wrote:
>> Sounds like bad memory. Run memtest for at least 24hrs.
>
Did so. After quite some time memtest found errors. Switching the
module in question resolved the issue. Thanks for the great feedback :)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHmbcyZhAcjSIb10ERCr6tAJ0WHLhkWo3ECzU3bTAc7s12AFCMAACfeBJA
edFGWUEOx6cGyA6JzUBzKjE=
=o91U
-----END PGP SIGNATURE-----

