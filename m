Return-Path: <linux-kernel-owner+w=401wt.eu-S1751252AbXA2Mop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbXA2Mop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 07:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXA2Mop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 07:44:45 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:53656 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbXA2Moo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 07:44:44 -0500
Date: Mon, 29 Jan 2007 13:44:42 +0100 (MET)
From: Oliver Neukum <oliver@neukum.name>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: blacklist kernel boot option
User-Agent: KMail/1.9.1
Cc: Gerd Hoffmann <kraxel@suse.de>, linux-kernel@vger.kernel.org
References: <200701270222.36060.mista.tapas@gmx.net>
 <45BDD9C2.1020309@suse.de>
 <Pine.LNX.4.61.0701291331060.32356@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0701291331060.32356@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701291344.45299.oliver@neukum.name>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GP
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 29. Januar 2007 13:40 schrieb Jan Engelhardt:
> >Is that an real-live issue, with distro kernels being shipped with
> >almost everything compiled as module these days?
> 
> For me it was. FC6 has at least CONFIG_MD=y, and SUSE also has some =y that
> could be =m with the help of module autoload rules, and some =y that could
> truly be =m. Those being =y cannot be blacklisted.

What use is it to modularly compile something that almost everybody needs?

	Regards
		Oliver
