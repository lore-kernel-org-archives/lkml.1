Return-Path: <linux-kernel-owner+w=401wt.eu-S1758733AbXHKROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbXHKROU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 13:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXHKROK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 13:14:10 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56905 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbXHKROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 13:14:08 -0400
X-Sasl-enc: PFmoKbuKPzleUIScxll6+wp/o4HDyS5jc017InTVPDFn 1186852447
Date: Sat, 11 Aug 2007 14:14:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Yan Burman <burman.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH 2.6.23-rc2]  hwmon: HP Mobile Data Protection System 3D
	ACPI driver (resend)
Message-ID: <20070811171404.GC18503@khazad-dum.debian.net>
References: <1186831562.6452.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186831562.6452.10.camel@localhost>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007, Yan Burman wrote:
> 3) Provides an interface similar to hdaps, so that hdapsd could work with it

Well, useful HDAPS (the one that is not in-tree :p, see
http://thinkwiki.org/wiki/Tp_smapi, it is distributed as a patch in
tp_smapi) is moving to an input device interface.  That sysfs attribute
"position" was a *bad* way to do it, really.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
