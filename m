Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477AbZCPW0i (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 16 Mar 2009 18:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbZCPW01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:26:27 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:57578 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZCPW00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZO9g0xcn0kn5jiRRJHXQ/CTxhAeLF1t47iXOcZ0J6rgQDD88G03dHxWQdq6vfsWpfw
         c9QzZGODasc8rbOmKCiUGUFcDAjZqXFMp4z2Ek7sktdHBnRAEXuytw3jmoqvqTTZ4uw9
         Y/y00m5R23wZ1smbsxq+hiJbZU0yBHBlWoyIo=
MIME-Version: 1.0
In-Reply-To: <1237237216.1035.195.camel@localhost.localdomain>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
	 <20090311232356.GP13540@fieldses.org>
	 <20090312161047.GA15209@us.ibm.com>
	 <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
	 <20090313175848.GB27891@fieldses.org>
	 <f44001920903131137j158c5f76y6a71b58ee964df77@mail.gmail.com>
	 <20090313190002.GA16025@us.ibm.com>
	 <1237227705.1035.93.camel@localhost.localdomain>
	 <20090316184926.GA6729@us.ibm.com>
	 <1237237216.1035.195.camel@localhost.localdomain>
Date: Tue, 17 Mar 2009 01:26:22 +0300
Message-ID: <f44001920903161526r1c498c0o4c52a014def63785@mail.gmail.com>
Subject: =?KOI8-R?Q?Re=3A_=EF=D4=D7=C5=D4=3A_VFS=2C_NFS_security_bug=3F_Should_CAP=5FMK?=
	=?KOI8-R?Q?NOD_and_CAP=5FLINUX=5FIMMUTABLE_be_added_to_CAP=5FFS=5FMASK=3F?=
From: Igor Zhbanov <izh1979@gmail.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
   "J. Bruce Fields" <bfields@fieldses.org>,
   Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
   viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
   David Howells <dhowells@redhat.com>, Andrew Morgan <morgan@kernel.org>,
   James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
   SELinux <selinux@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here you can find who and how use setfsuid(...):
http://www.google.com/codesearch?hl=ru&sa=N&q=%5B%5E_%5Dsetfsuid%5B%5C+%5Ct%5D*%5C(%5Ba-z_%5D%2B+file:%5C.%5Bch%5D%5Bcpx%5D*%24
