Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYBFRTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYBFRTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYBFRTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:19:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:19403 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbYBFRTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:19:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,313,1199692800"; 
   d="scan'208";a="514288063"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: ipw3945: not only it periodically dies, it also BUG()s
Date: Wed, 6 Feb 2008 09:13:34 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003982E4C@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20080206143218.GA16188@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ipw3945: not only it periodically dies, it also BUG()s
Thread-Index: AchozWuMaZw4iKUQRQC7JPMNB4+UBgAFeKAA
References: <20080205214441.GA1518@elf.ucw.cz> <D936D925018D154694D8A362EEB0892003982BB1@orsmsx416.amr.corp.intel.com> <20080206143218.GA16188@elf.ucw.cz>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <ipw3945-devel@lists.sourceforge.net>, <linux-wireless@vger.kernel.org>,
       "Zhu, Yi" <yi.zhu@intel.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Feb 2008 17:13:35.0820 (UTC) FILETIME=[9BA4E8C0:01C868E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2008 6:32 AM, Pavel Machek wrote:

> On Tue 2008-02-05 18:20:58, Chatre, Reinette wrote:
>> On Tuesday, February 05, 2008 1:45 PM, Pavel Machek  wrote:
>> 
>>> 
>>> ...I've reported this before, with full debugging. Not sure if
>>> anything happened.
>> 
>> Could you please point me to where you have reported it before?
> 
> From pavel@ucw.cz Wed Oct 31 01:52:02 2007
> From: Pavel Machek <pavel@ucw.cz>
> To: linux-wireless@vger.kernel.org,
>        kernel list <linux-kernel@vger.kernel.org>,
>        ipw3945-devel@lists.sourceforge.net, yi.zhu@intel.com
> Subject: iwl3945 in 2.6.24-rc1 dies under load
> X-Warning: Reading this can be dangerous to your mental health.
> 
> ...and thread that resulted.

Could you please create a new bug in our bug tracking system
(www.bughost.org) to enable us to track this problem? Please include the
relevant information from the thread as well as the information you
doscovered recently.

Thank you very much

Reinette

