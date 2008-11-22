Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYKVWME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYKVWME (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbYKVWLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:11:50 -0500
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:37428 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYKVWLt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:11:49 -0500
X-Greylist: delayed 1202 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Nov 2008 17:11:48 EST
From: "Moore, Eric" <Eric.Moore@lsi.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: Alan Piszcz <ap@solarrain.com>
Date: Sat, 22 Nov 2008 14:51:23 -0700
Subject: RE: Question regarding SAS controllers.
Thread-Topic: Question regarding SAS controllers.
Thread-Index: AclM6+iy8j2ZFGZTTtKE+gi95ODl1AAAGVOw
Message-ID: <660360F4F2570145BD872F298951B17A5CC40737@cosmail03.lsi.com>
In-Reply-To: <alpine.DEB.1.10.0811221645250.707@p34.internal.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 22, 2008 2:47 PM, Justin Piszcz wrote:

> Do any SAS controllers exist that are not RAID?
>
> Or to put it another way, if one wants to use SAS disks for
> example and
> NOT export them as JBOD or use them as RAID, is there a
> normal controller?
>
> Back in the days of regular SCSI you had SCSI controllers and
> SCSI raid
> controllers, when searching for SAS controllers now, all that
> comes up is
> hundreds of SAS-Raid controllers.
>

mptsas

http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/index.html

Eric Moore
