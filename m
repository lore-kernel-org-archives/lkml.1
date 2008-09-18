Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYIRPiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYIRPiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 11:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbYIRPh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 11:37:58 -0400
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:2501 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYIRPh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 11:37:57 -0400
X-Greylist: delayed 443 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 11:37:57 EDT
Date: Thu, 18 Sep 2008 17:30:32 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: ACPI idea: override max. frequency
Message-ID: <20080918153032.GU4323@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Wed Sep 17 21:27:26 CEST 2008
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The bios of the motherboard in my pc (a Gigabyte 965G-DS3) says the
processor can go no faster than 2.133GHz while in reality this is 2.6GHz
(it is an Intel(R) Core(TM)2 Quad CPU Q9450 @ 2.66GHz). No newer bios is
available so I was thinking: maybe an override switch can be added?
Losing 0.5GHz is a bit of a waste.


Folkert van Heusden

-- 
Ever wonder what is out there? Any alien races? Then please support
the seti@home project: setiathome.ssl.berkeley.edu
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
