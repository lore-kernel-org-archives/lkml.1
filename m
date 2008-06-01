Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYFAQDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYFAQDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 12:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYFAQDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 12:03:13 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59222 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYFAQDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 12:03:12 -0400
X-Sasl-enc: SIdQh/Qzmd6P3r5y3fSXiUPmSdr1XRJ0skCCAfvh9OSg 1212336191
Date: Sun, 1 Jun 2008 13:03:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Renato S. Yamane" <yamane@diamondcut.com.br>,
       linux-kernel@vger.kernel.org
Subject: Re: [Bug 10797] Something is consuming power after shutdown
Message-ID: <20080601160308.GA14895@khazad-dum.debian.net>
References: <483AB443.6020807@diamondcut.com.br> <20080531074433.GE5405@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531074433.GE5405@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008, Pavel Machek wrote:
> (And yes, your hw is broken; on pc it is traditionaly hw
> responsibility to power machine down.)

Something changed in the laptop vendor's minds about this since Vista.
Very new ThinkPads also had this problem (I am not sure it has been
fixed already or not).

We may have to start shutting down every device and bus on our way out
for lunch when told to go into S5, now.  Time will tell.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
