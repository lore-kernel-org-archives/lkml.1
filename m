Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014Ab0AUCEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0AUCEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 21:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190Ab0AUCEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 21:04:33 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:59566 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab0AUCEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 21:04:32 -0500
X-Sasl-enc: rurYSLvOHPnJHX80na+TfDkfIEe0yCdEWO3p7pyRRL94 1264039471
Date: Thu, 21 Jan 2010 00:04:28 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: ibm-acpi-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: wrong thermal
 attribute_group removed in thermal_exit()
Message-ID: <20100121020428.GC5683@khazad-dum.debian.net>
References: <4B560F33.1080805@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B560F33.1080805@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010, Roel Kluin wrote:
> sysfs_remove_group() removed the wrong attribute_group for 
> thermal_read_mode TPEC_8, ACPI_TMP07 and ACPI_UPDT
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

I will queue it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
