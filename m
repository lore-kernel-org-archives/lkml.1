Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbXFNUUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbXFNUUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXFNUUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:20:48 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:60897 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbXFNUUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:20:47 -0400
Date: Thu, 14 Jun 2007 22:20:47 +0200
From: DervishD <lkml@dervishd.net>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070614202047.GD1928@DervishD>
Mail-Followup-To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070611101319.GA14284@DervishD> <20070614174509.GB31984@lazybastard.org> <20070614182201.GD31984@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614182201.GD31984@lazybastard.org>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jörn :)

 * Jörn Engel <joern@logfs.org> dixit:
> Any method I can imagine to offer good wear leveling will result in
> either a filesystem or at least a simplified one-file-system with the
> only file being the "block device" exported outward.  So naturally my
> answer to the problem is called LogFS. :)

    I'm with you in that. So stop emailing and go working on it XD

    Now seriously, I will take a look at LogFS from time to time, and if
you want me to, I can do tests on my Kingston DT.

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
