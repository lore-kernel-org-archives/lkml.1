Return-Path: <linux-kernel-owner+w=401wt.eu-S1751108AbXBMF4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbXBMF4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 00:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbXBMF4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 00:56:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:9169 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXBMF4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 00:56:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,161,1170662400"; 
   d="scan'208"; a="196069513:sNHT19991405"
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-2"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: /proc/acpi/ac_adapter/AC is missing after latest ACPI merge
Date: Tue, 13 Feb 2007 08:56:14 +0300
Message-ID: <8E389A5F2FEABA4CB1DEC35A25CB39CEA63B25@mssmsx411>
In-Reply-To: <200702122045.34951.ismail@pardus.org.tr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: /proc/acpi/ac_adapter/AC is missing after latest ACPI merge
Thread-Index: AcdO1iZAlu8TnNDBQiSwcHONbHiqqAAWyGew
From: "Lebedev, Vladimir P" <vladimir.p.lebedev@intel.com>
To: =?ISO-8859-2?Q?Ismail_D=F6nmez?= <ismail@pardus.org.tr>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 13 Feb 2007 05:56:19.0211 (UTC) FILETIME=[AE73F5B0:01C74F33]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 12 February 2007 13:45, Ismail Dönmez wrote:

> Hi all,
> 
> After latest ACPI merge /proc/acpi/ac_adapter/AC has gone fishing :
> 
> [~]> ls -al /proc/acpi/ac_adapter/
> dr-xr-xr-x  2 root root 0 ªub 12 20:44 ADP1
> 
> [~]> ls -al /proc/acpi/ac_adapter/ADP1
> -r--r--r-- 1 root root 0 ªub 12 20:44 state
> 
> This at least breaks HAL which thinks AC is always plugged in, is this change 
> intentional?

Could you please clarify what is incorrect - ADP1 name ...? Why does HAL think so?

Thanks.
Vladimir.
