Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbXGCMzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbXGCMzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 08:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXGCMzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 08:55:35 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:28495 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753256AbXGCMzf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 08:55:35 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.21.5 june 30th to july 1st date hang?
Date: Tue, 3 Jul 2007 08:55:12 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128A5D@ecqcmtlmail3.quebec.int.ec.gc.ca>
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.21.5 june 30th to july 1st date hang?
Thread-Index: Ace9b9Q0ajy9G3UNTkCPl8PiFXbdoQAALQ2w
References: <F1D642E5A91BC94D9504EC83AE19E6B0128A5C@ecqcmtlmail3.quebec.int.ec.gc.ca>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Jul 2007 12:55:12.0784 (UTC) FILETIME=[650FD900:01C7BD71]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Message d'origine-----
> De : linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] De la part de 
> Fortier,Vincent [Montreal]
> Envoyé : 3 juillet 2007 08:44
> 
> Hi all,
> 
> All my servers and workstations running a 2.6.21.5 kernel 
> hanged exactly when the date shift from june 30th to july 1st.
> 
> On my monitoring system every single station running a 
> 2.6.21.5 kernel stoped responding exactly after midnight on 
> the date shift from June 30th to July 1st.  Although, 
> stations still running 2.6.18 to 2.6.20.11 worked flawlessly.
> 
> I first tought there had been an electricity outage but two 
> of my servers (dell PE 2950 dual-quad core) on UPS in our 
> server room also
> hanged:
> Jun 30 23:55:01 urpdev1 /USR/SBIN/CRON[31298]: (root) CMD ([ -x
> /usr/lib/sysstat/sa1 ] && { [ -r "$DEFAULT" ] && . "$DEFAULT" 
> ; [ "$ENABLED" = "true" ] && exec /usr/lib/sysstat/sa1; }) 
> Jul  3 11:54:03 urpdev1 syslogd 1.4.1#17: restart.
> 
> I could not get anything on any of the 20+ consoles...  All 
> the systems hanged at around the exact same time... When the 
> date shifted from June 30th to July 1st in UTC ...?
> 
> Any clue any one?

Forgot to mention:

- All stations that failed where running a 2.6.21 kernel + CFS v18 (I don't have any stations running a plain 2.6.21 kernel so can't tell)
- Config file can be found at: http://linux-dev.qc.ec.gc.ca/kernel/debian/CONFIG-i686-2.6.21-005
- kernels can be found at: http://linux-dev.qc.ec.gc.ca/kernel/debian/sarge/i686/2.6.21/

> 
> - vin
> 
