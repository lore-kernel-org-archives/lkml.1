Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYIHUYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYIHUYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYIHUYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:24:37 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49501 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbYIHUYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:24:36 -0400
X-Sasl-enc: 0WFZdZmAXOECPXvKagMPOm+WLg+sgWk50V3Hx9D4nPPm 1220905475
Date: Mon, 8 Sep 2008 17:24:32 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Daniel Barkalow <barkalow@iabervon.org>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
Message-ID: <20080908202432.GA9908@khazad-dum.debian.net>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz> <20080902083940.ZZRA012@mailhub.coreip.homeip.net> <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz> <20080903101947.ZZRA012@mailhub.coreip.homeip.net> <20080903213258.GC14620@khazad-dum.debian.net> <48C57FDE.2010306@diamondcut.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C57FDE.2010306@diamondcut.com.br>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2008, Renato S. Yamane wrote:
> Henrique de Moraes Holschuh wrote:
> > I fell I need to warn you guys that you are likely breaking machines that
> > match that DMI info but have a newer BIOS, unless they use different BIOSes
> > (not enough data without a full dmidecode output from the other machine).
> 
> dmidecode just from 3000-N100?

No, we'd need the dmidecode output of the two *specific* 3000-N100
machines involved in the issue, so that we can know the specific BIOS
version they are running.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
