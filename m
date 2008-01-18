Return-Path: <linux-kernel-owner+w=401wt.eu-S1760411AbYARMpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760411AbYARMpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYARMpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:45:36 -0500
Received: from bay0-omc3-s30.bay0.hotmail.com ([65.54.246.230]:14962 "EHLO
	bay0-omc3-s30.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756286AbYARMpf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:45:35 -0500
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2008 07:45:35 EST
Message-ID: <BAY133-W31506ED3DE3D365F0ACC6B80420@phx.gbl>
X-Originating-IP: [194.254.163.24]
From: antares atlantide <antares.atlantide@hotmail.fr>
To: <linux-kernel@vger.kernel.org>
Subject: kernel: EDAC e752x: Non-Fatal Error PCI Express B
Date: Fri, 18 Jan 2008 13:38:19 +0100
Importance: Normal
In-Reply-To: <20080118123324.GJ11044@elte.hu>
References: <478FAC91.90109@goop.org> <20080118123324.GJ11044@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 18 Jan 2008 12:38:19.0405 (UTC) FILETIME=[013EBBD0:01C859CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I am using this kernel and this OS on PC Dell SMT670 with processor  Intel Corporation E7525 
 
Linux l2.6.22-3-686 #1 SMP Mon Oct 22 22:11:56 UTC 2007 i686 GNU/Linux
Debian GNU/Linux lenny/sid 
 
When i am using the printer with the application acroread and evince , sometimes i have no response and I have this error
 
root@lyonesse:~# cat /var/log/syslog | grep  EDAC
Jan 17 11:04:08 lyonesse kernel: EDAC e752x: Non-Fatal Error PCI Express B
Jan 17 11:04:09 lyonesse kernel: EDAC e752x: Non-Fatal Error PCI Express B
 
and the other one
 
 
root@troie:~#  cat /var/log/syslog | grep  EDAC
Jan 17 15:08:18 troie kernel: EDAC MC: Ver: 2.0.1 Oct 22 2007
Jan 17 15:08:18 troie kernel: EDAC e752x: tolm = 40000, remapbase =
ffc000, remaplimit = 0
Jan 17 15:08:18 troie kernel: EDAC MC0: Giving out device to e752x_edac
E7525: DEV 0000:00:00.0

Antares
_________________________________________________________________
Microsoft vous offre un logiciel pour classer, retoucher et partager vos photos !
http://www.windowslive.fr/galerie/