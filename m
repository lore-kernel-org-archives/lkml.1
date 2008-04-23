Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYDWV31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYDWV31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYDWV3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:29:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:62535 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYDWV3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:29:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,701,1199692800"; 
   d="scan'208";a="320576896"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: iwl4965 regression since 2.6.24
Date: Wed, 23 Apr 2008 14:29:14 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004415BC8@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20080423124105.GA4783@ics.muni.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: iwl4965 regression since 2.6.24
Thread-Index: AcilP2WppMxMo+6/T+iGVvW0u6hAzwASWovw
References: <20080423124105.GA4783@ics.muni.cz>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>, <linux-kernel@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>
X-OriginalArrivalTime: 23 Apr 2008 21:29:15.0014 (UTC) FILETIME=[1452EA60:01C8A589]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On , linux-wireless-owner@vger.kernel.org  wrote:

> Hello,
> 
> as of 2.6.25 kernel, the intel driver iwl4965 has serious troubles to
> associate with AP. I must many times set essid till the
> association is done.
> 
> Moreover, it seems that it is unable to associate with
> different AP (using the
> same SSID). I must remove the module completly to be able to
> associate to the different AP. I think it is big regression.
> 

Could you please send us some logs that can help us debug this problem?
Please load the driver with debugging (modprobe iwl4965 debug=0x43ffb)
to get detailed logs and add a detailed description about what you are
trying to do with the driver as the logs are created. Also, please
consider filing a bug at http://www.intellinuxwireless.org/bugzilla/
with these logs attached.

Thanks

Reinette
