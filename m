Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbZKXA5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbZKXA5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757639AbZKXA5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:57:18 -0500
Received: from ozlabs.org ([203.10.76.45]:51684 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630AbZKXA5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:57:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the kernel (__ksymtab)
Date: Tue, 24 Nov 2009 11:27:17 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Tony Luck <tony.luck@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Mike Frysinger <vapier.adi@gmail.com>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <4B072E31.4000906@tuffmail.co.uk> <20091123195320.GD26810@ldl.fc.hp.com>
In-Reply-To: <20091123195320.GD26810@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911241127.18013.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 06:23:20 am Alex Chiang wrote:
> Hi Alan, Rusty,

Hi Alex,

> In the meantime, while Alan is deciding the proper way to fix
> this, would it be possible to drop the offending patch series
> from linux-next?

Done.  That takes the pressure off Alan, and makes sure he has time to get
it right.

Thanks,
Rusty.

