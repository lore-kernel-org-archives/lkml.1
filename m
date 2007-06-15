Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbXFOIBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbXFOIBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbXFOIBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:01:01 -0400
Received: from host94-205-static.22-80-b.business.telecomitalia.it ([80.22.205.94]:40969
	"EHLO waobagger.intranet.nucleus.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751513AbXFOIBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:01:01 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 04:00:57 EDT
From: Massimiliano Hofer <max@nucleus.it>
To: linux-kernel@vger.kernel.org
Subject: Re: spurious completions during NCQ?
Date: Fri, 15 Jun 2007 09:51:57 +0200
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Florin Iucha <florin@iucha.net>,
       Tejun Heo <htejun@gmail.com>, Robert Hancock <hancockr@shaw.ca>
References: <fa.Nigm+GFAuAW+QzfgqTUfmHJoFfU@ifi.uio.no> <20070608131157.GH30661@iucha.net> <20070608162802.7d5bc66a@the-village.bc.nu>
In-Reply-To: <20070608162802.7d5bc66a@the-village.bc.nu>
X-Face: K`wgvx&HhZL9|Oz+ZIU$]O&CG5N(Zr(QXdPZhk~,S*XNK9.}0u`+=SwR|^2cW.{Ei}F'0(=?iso-8859-1?q?=0A=09q?=>|]o"}A4'HvAe=!Q_W/t9']yG%RA'[j6iX8
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150951.58586.max@nucleus.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 8 June 2007, Alan Cox wrote:

> > 	Model Number:       HITACHI HTS541680J9SA00
> > 	Serial Number:      SB******I57L4A
>
> This one is already blacklisted in the windows drivers.

I have the same problem with this drive (shipped with a Thinkpad Z61m):

        Model Number:       HITACHI HTS541612J9SA00
        Firmware Revision:  SBDIC7JP

It reported several dozen spurious completions over a few days, but I can't 
find any corruption. Is it really dangerous? I understand this clearly is a 
firmware bug, but I'm not sure how to interpret the drive behavior.
I can perform any test you like, if you find it useful.

-- 
Saluti,
   Massimiliano Hofer
