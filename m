Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYKFVPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYKFVPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYKFVPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:15:23 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:60193 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225AbYKFVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:15:21 -0500
X-Sasl-enc: lR0G8bsSTIVMsifCcc2WwKegYYoB5uhdkvTlInwi9ePn 1226006119
Date: Thu, 6 Nov 2008 19:15:17 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081106211517.GA6477@khazad-dum.debian.net>
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net> <20081105130852.GB30758@dose.home.local> <20081105162401.GF14931@khazad-dum.debian.net> <20081106003543.GA14766@x61> <20081106141121.GB23278@khazad-dum.debian.net> <20081106153215.GA23739@x61>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106153215.GA23739@x61>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008, Tino Keitel wrote:
> Maybe the level values should be changed to describe this order.
> Currently, it's AUTO (0x80) > full-speed (0x40) > 7. There are already
> 29(!) functions just for the fan handling, so there should be enough
> room for a bit of abstraction. :-) I think it could have the benefit of code
> which is easier to read and maintain. Correct me if I'm wrong.

I will think about it.  It wouldn't hurt.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
