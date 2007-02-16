Return-Path: <linux-kernel-owner+w=401wt.eu-S1945973AbXBPQQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945973AbXBPQQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945976AbXBPQQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:16:54 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:60497 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945973AbXBPQQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:16:53 -0500
From: Dan Smith <danms@us.ibm.com>
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [BUG?] register_blkdev: failed to get major for device mapper
References: <200702161437.34063.eike-kernel@sf-tec.de>
Date: Fri, 16 Feb 2007 08:16:44 -0800
In-Reply-To: <200702161437.34063.eike-kernel@sf-tec.de> (Rolf Eike Beer's
	message of "Fri, 16 Feb 2007 14:37:28 +0100")
Message-ID: <m3bqju6psj.fsf@guaranine.beaverton.ibm.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

RB> The error message is quoted in subject.

I was seeing this behavior a couple days ago.  I had been ignoring the
warnings about using the known-broken gcc 4.1.0; updating to 4.1.1
fixed it for me.

- -- 
Dan Smith
IBM Linux Technology Center
Open Hypervisor Team
email: danms@us.ibm.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF1djxwtEf7b4GJVQRAlUAAKCHIuPS5dRCXxiw5yHEMleGZlV3wQCeM8Xu
Z8T/nOT2L9Pe0O3ItMBu9pY=
=gn5n
-----END PGP SIGNATURE-----
