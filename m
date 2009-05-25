Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZEYVUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZEYVUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZEYVUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:20:07 -0400
Received: from main.gmane.org ([80.91.229.2]:49540 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409AbZEYVUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:20:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?ISO-8859-1?Q?Simon_K=F6nig?= <simjoko@gmail.com>
Subject: Re: Unable to compile 2.6.30-rc7 on RHEL 4 - GCC 3.4.6
Date: Mon, 25 May 2009 23:17:29 +0200
Message-ID: <gvf1ti$77e$1@ger.gmane.org>
References: <f24d23310905250956u231fcd90u54d75894b9b91b9a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p54a8d081.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1pre) Gecko/20090525 Shredder/3.0b3pre
In-Reply-To: <f24d23310905250956u231fcd90u54d75894b9b91b9a@mail.gmail.com>
X-Enigmail-Version: 0.96a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/25/09 18:56, debian developer wrote:
> Hi all,
> 
> I am getting this error when trying to compile the latest rc:
> 
> /in/inndesk171/linux-2.6.28/arch/x86/Makefile:82: stack protector
> enabled but no compiler support

Hello!

As the message states, your compiler does not support this kernel feature.
You may want to disable CC_STACKPROTECTOR or use a gcc >= 4.2.

Regars,
Simon

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkobCukACgkQzCF5U5e0QtICCACfXka95a8Tn9YlYRte+9zYwTZN
bpAAn0xxkUuiTE1T7gDqTmyXJurFhQ8Q
=wjdI
-----END PGP SIGNATURE-----

