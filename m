Return-Path: <linux-kernel-owner+w=401wt.eu-S965309AbXCAQAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965309AbXCAQAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXCAQAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:00:15 -0500
Received: from smtp01.cdmon.com ([86.109.99.230]:49726 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965309AbXCAQAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:00:14 -0500
Date: Thu, 1 Mar 2007 17:01:39 +0100
From: DervishD <lkml@dervishd.net>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
       Linux Fbdev development list 
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: tdfx framebuffer garbles display in 2.6.19.5
Message-ID: <20070301160139.GA102@DervishD>
Mail-Followup-To: "Antonino A. Daplas" <adaplas@gmail.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>,
	Linux Fbdev development list <linux-fbdev-devel@lists.sourceforge.net>
References: <20070226144744.GA3615@DervishD> <1172503471.20842.14.camel@daplas> <20070226171334.GB13496@DervishD> <1172510654.7101.11.camel@daplas> <20070226203223.GA161@DervishD> <1172617755.13422.0.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1172617755.13422.0.camel@daplas>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Antonino :)

 * Antonino A. Daplas <adaplas@gmail.com> dixit:
> Can you try this patch?  It might help with the screen corruption.

    With the patch, the scroll slows to a crawl and the system is
unusable. The time to scroll 30 lines is about a minute or so (probably
more, I just measured for a while).

    If you want me to test other patches, just tell :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
