Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbZBXVXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbZBXVXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZBXVXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:23:15 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:35310 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZBXVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:23:14 -0500
Message-ID: <49A46562.7050906@oracle.com>
Date: Tue, 24 Feb 2009 13:23:46 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: List of 404 URLs in kernel .c and .h files
References: <1235506239.2501.46.camel@localhost>
In-Reply-To: <1235506239.2501.46.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49A4651D.0108:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Any suggestions on what if anything should be done
> to the sources with these dead links?
> 
> http://foo.com/bar/baz.html

That's just an example/dummy URL.

> http://openib.org/license.html

maybe http://www.openib.org/software_license.htm

> http://pci-ids.ucw.cz/iii

just use http://pci-ids.ucw.cz/

> http://prism54.org/supported_cards.php

maybe http://wireless.kernel.org/en/users/Drivers/p54

> http://sourceforge.net/project/openipmi

                        /projects/

> http://www.ftdi.co.uk

http://www.ftdichip.com/

> http://www.highpoint-tech.com/BIOS

Did the script truncate the URL?  I see:
./drivers/ide/hpt366.c:15: * available from http://www.highpoint-tech.com/BIOS%20+%20Driver/.

> http://www.kernel.org/log

not a problem AFAICT.

> http://www.lanana.org/docs/device-list/devices-2.6

http://www.lanana.org/docs/device-list/devices-2.6+.txt

another script glitch?

> http://www.linuxjournal.com/article.php

another script problem AFAICT.

> http://www.national.com/pf/DP/DP83840.html

http://www.national.com/opf/DP/DP83840A.html

> http://www.nluug.nl/events/sane2000/papers.html

http://www.sane.nl/events/sane2000/papers.html

> http://www.siliconimaging.com/RGB

another script glitch.

> http://www.torque.net/sg
> http://www.torque.net/sg/p/scsi-generic_long.txt
> http://www.torque.net/sg/p/scsi-generic.txt
> http://www.torque.net/sg/p/sg_v3_ho.html
> http://www.torque.net/sg/sdebug26.html
> http://www.torque.net/sg/sg_io.html

http://sg.danny.cz/sg/


-- 
~Randy
