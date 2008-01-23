Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYAWQNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYAWQNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 11:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbYAWQMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:12:54 -0500
Received: from gate.crashing.org ([63.228.1.57]:47749 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbYAWQMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:12:52 -0500
Cc: Vitaly Bordug <vitb@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Message-Id: <8390AE9D-AB54-4D7A-840E-0D08637B50FE@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jochen Friedrich <jochen@scram.de>
In-Reply-To: <47976499.9050505@scram.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCHv2 4/8] [POWERPC] Remove declaration of m8xx_pic_init.
Date: Wed, 23 Jan 2008 10:07:30 -0600
References: <47976499.9050505@scram.de>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23, 2008, at 10:00 AM, Jochen Friedrich wrote:

> m8xx_pic_init is declared in ppc8xx_pic.h but defined nowhere in the  
> ppc
> tree. Remove it.
>
> Signed-off-by: Jochen Friedrich <jochen@scram.de>

if we respin the patches, merge this with 2/8 - Rename m8xx_pic_init  
to mpc8xx_pics_init.

(otherwise i'll merge when I commit).

- k
