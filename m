Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXLSSaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXLSSaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 13:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbXLSSaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 13:30:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57926 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbXLSSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 13:30:06 -0500
Date: Wed, 19 Dec 2007 19:30:05 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Peters, Gordon" <gordon.peters@intel.com>
cc: "Gosney, JeremiX" <jeremix.gosney@intel.com>, linux-kernel@vger.kernel.org,
       "Sy, Dely L" <dely.l.sy@intel.com>
Subject: RE: ARP Bug?
In-Reply-To: <3A64AD58EE71B34FB333E733C62CDE3C04A83F60@orsmsx414.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0712191929430.12329@fbirervta.pbzchgretzou.qr>
References: <F2B6B9EAC551DA4AA8833629D55D9CA8482D4C@orsmsx418.amr.corp.intel.com>
 <Pine.LNX.4.64.0712150231090.22877@fbirervta.pbzchgretzou.qr>
 <3A64AD58EE71B34FB333E733C62CDE3C04A83F60@orsmsx414.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 19 2007 09:47, Peters, Gordon wrote:

>Call me crazy,

For top-posting, yes. :)

> but if I have 2 NICs in a system and all the traffic is
>going through one of them and then that one NIC cable gets pulled, the
>other NIC, that half of the traffic should have been going through in
>the first place, should still work. However, with this type of
>functionality, it does not. Effectively both NICs are now dead even
>though the cable has only been pulled from eth0. Once you pull the cable
>to that "primary" NIC, all traffic stops; even when the "secondary" NIC
>is up and working fine. That in my professional opinion is broken.

I think you should finally reveal your interface configuration
otherwise it's all smoke and mirrors.
