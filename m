Return-Path: <linux-kernel-owner+w=401wt.eu-S1755979AbZLDLOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbZLDLOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbZLDLOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:14:40 -0500
Received: from paperstreet.colino.net ([213.41.244.236]:52925 "EHLO
	paperstreet.colino.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbZLDLOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:14:39 -0500
Date: Fri, 4 Dec 2009 12:14:41 +0100
From: Colin Leroy <colin@colino.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jean Delvare <khali@linux-fr.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
       "Darrick J. Wong" <djwong@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] therm_adt746x is unmaintained
Message-ID: <20091204121441.08cccb35@paperstreet.colino.net>
X-Mailer: Claws Mail 3.7.3cvs10 (GTK+ 2.16.1; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEUAAwASFBYfISMyMTRGRUdaWFdxb2yJhoKrqaPOzMT19Ow5JzfkAAACW0lEQVQ4y6WTP1PbMBjGo6T/RkmmLWxIotCxtkRpmYqVMLAFY2i7AU0DbEDACVOvd6aED9DYnntg61NWCo0tt2N1vpyjn5/30ftIajT+Z4BVLLw3/0w7a+MsVXln8a/5x+E47fXT5FLW55ubP0ZFViTj6KImcXb7l5Pr4XD4JQo3bNDSVdIbLgLhd3ZssLwXHyUXwheACWnXivrx13bHRU3ECHMt6yjsDA8XIWygJsZeBZ5E/mrHBwAgpB9W1XodSw+Dh3cEvA8lODrQVR5i0Q8pTUB0Dq3I3LKTR/3cQyXC5KzM6b1Kugj9+YfI91LxWaUHej1gqsL0vAzkSiUHZqXGFToWuFUTSRHExEiarAsrcO1ThPDUpuVszAC4KgbcI7plQ5q4Cus2Dzh30e72w3ekbCnpSSERXpJGAdhs4Y35ImZiLVNn0y7RyqxzcKvUwDtRKne5JnhuFmJLKXXnZ/p3X0tAZQ4MONUy1UWgAXG1H/rj/HRLA1fbQuCUYN1Ueakp0UkCwMqgW1mhTvFxca67hxDxEoCtvNhHDtd5IQAc65Qs5PcSMbHjasD96iyA+TymlEujcIoza5tfFGlAKOceQm9VYG2/KFRAGeeUoOXUPtRsMupxJrkutTSuXYPonT4MbaNYOq6BlVHAPWEA34O1i5YGQmoPXWsP1a7aeEI5oxRj9LEOtu449SgmBB6FtVpPB9rBDChuagDs8Okg4FVG7Ft7eRKLtmnEWc66Fvg0Wc/boeQu7u6Ovln2PwcL6ZdO2yOrz3ujX6BySA6fpXEovbntcHNwb9x/A34/oQVbOAIKAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't have the hardware to maintain the ADT746X fan driver anymore.
Here's a patch to update the status of the driver.

Signed-off-by: Colin Leroy <colin@colino.net>

--- a/MAINTAINERS	2009-12-04 12:09:59.000000000 +0100
+++ b/MAINTAINERS	2009-12-04 12:10:00.000000000 +0100
@@ -322,11 +322,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	drivers/net/wireless/adm8211.*
 
-ADT746X FAN DRIVER
-M:	Colin Leroy <colin@colino.net>
-S:	Maintained
-F:	drivers/macintosh/therm_adt746x.c
-
 ADVANSYS SCSI DRIVER
 M:	Matthew Wilcox <matthew@wil.cx>
 L:	linux-scsi@vger.kernel.org

-- 
Colin
