Return-Path: <linux-kernel-owner+w=401wt.eu-S1758463AbXFMMp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463AbXFMMp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbXFMMpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:45:21 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:52942 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757625AbXFMMpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:45:21 -0400
Date: Wed, 13 Jun 2007 15:44:31 +0200
From: DervishD <lkml@dervishd.net>
To: Bernd Eckenfels <ecki@lina.inka.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext2 on flash memory
Message-ID: <20070613134431.GB1983@DervishD>
Mail-Followup-To: Bernd Eckenfels <ecki@lina.inka.de>,
	linux-kernel@vger.kernel.org
References: <11f674920706111735l7dec2136t32d40ee2ab4ccca4@mail.gmail.com> <E1Hxv1g-0000X1-00@calista.eckenfels.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1Hxv1g-0000X1-00@calista.eckenfels.net>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Bernd :)

 * Bernd Eckenfels <ecki@lina.inka.de> dixit:
> In article <11f674920706111735l7dec2136t32d40ee2ab4ccca4@mail.gmail.com> you wrote:
> > All of the posts fail to address the question here: what is the
> > correct file system, or does one exist yet, for wear leveling flash
> > storage.  JFFS2 and logfs are nice for MTD, but for better flash
> > memories that are likely to be used in the future like solid state
> > hard disks, what is the answer?
> 
> FAT - you can stick it into Windows Boxes on the road.

    But then you lose the UNIX metadata. What if you want to keep the
UID/GID and mode (and any other metadata information, for that matter)?

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
