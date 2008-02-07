Return-Path: <linux-kernel-owner+w=401wt.eu-S1760192AbYBGBTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192AbYBGBTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 20:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYBGBS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 20:18:56 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33366 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbYBGBSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 20:18:55 -0500
X-Sasl-enc: GH90rZ5Oh20AK0P0ynnqanv21c31QMoDPmE5H3BYfWu3 1202347134
Date: Wed, 6 Feb 2008 23:18:50 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       len.brown@intel.com, ibm-acpi-devel@lists.sourceforge.net,
       linux-acpi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [PATCH][drivers/misc/thinkpad_acpi.c] duplicate test if (level
	& TP_EC_FAN_FULLSPEED)
Message-ID: <20080207011850.GC10122@khazad-dum.debian.net>
References: <47A78CBB.2090401@tiscali.nl> <ada8x20gykq.fsf@cisco.com> <47A79EC8.6060700@tiscali.nl> <20080205050504.GB30670@khazad-dum.debian.net> <47A81FAE.2090709@tiscali.nl> <20080206230702.GA12395@kroah.com> <47AA4748.3040702@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AA4748.3040702@tiscali.nl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008, Roel Kluin wrote:
> It's a oneliner and the patch is from linus' tree.

Roel, better to just let me and Len Brown handle it.  I will add your patch
to my thinkpad-acpi queue and send it to Len soon, along with other simple
patches that are pending.  Either I or Len will notify stable@k.o when it
hits mainline.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
