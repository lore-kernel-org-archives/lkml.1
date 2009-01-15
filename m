Return-Path: <linux-kernel-owner+w=401wt.eu-S1763433AbZAORwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763433AbZAORwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760395AbZAORwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:52:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:64176 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759133AbZAORwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:52:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,271,1231142400"; 
   d="scan'208";a="422698587"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Kyle McMartin <kyle@mcmartin.ca>
Date: Thu, 15 Jan 2009 09:52:33 -0800
Subject: RE: [mmotm][PATCH] fix ia64 build error
Thread-Topic: [mmotm][PATCH] fix ia64 build error
Thread-Index: Acl3N60VIeEeex6dRTKsde4dy8DqvQAAjqjw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA35CD25941@orsmsx505.amr.corp.intel.com>
References: <20090115200315.EBE3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20090115093514.f3f6b8ff.akpm@linux-foundation.org>
In-Reply-To: <20090115093514.f3f6b8ff.akpm@linux-foundation.org>
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

> I also don't know which linux-next tree added that commit.  There's a
> way of working this out but I forgot it.

Squinting at the lines on "gitk", it looks like it came
from the "cachefs" branch.

-Tony

