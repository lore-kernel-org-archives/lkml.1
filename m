Return-Path: <linux-kernel-owner+w=401wt.eu-S1758419AbZCTQGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbZCTQGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 12:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZCTQGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 12:06:09 -0400
Received: from norkia.v3.sk ([92.240.234.41]:50425 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbZCTQGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 12:06:09 -0400
Subject: Re: The Linux Staging tree, what it is and is not.
From: Lubomir Rintel <lkundrak@v3.sk>
To: Dave Airlie <airlied@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <21d7e9970903192126r69687891madbce3d5ee77f6a0@mail.gmail.com>
References: <20090318183232.GA11594@kroah.com>
	 <21d7e9970903192126r69687891madbce3d5ee77f6a0@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 17:05:58 +0100
Message-Id: <1237565158.32737.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 (2.25.92-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 14:26 +1000, Dave Airlie wrote:
> Staging doesn't fulfill this role from my POV:
> a) what sane distro will enable staging drivers? do they care about their users?

If the code there actually builds, I don't see a problem with packaging
the staging drivers into a -crap subpackage, or maybe blacklisting them
all by default, but saving the user who wants to cut his head off and
watch himself bleed from having to recompile the kernel package for
that.

-- 
Lubomir Rintel <lkundrak@v3.sk>

