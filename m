Return-Path: <linux-kernel-owner+w=401wt.eu-S1756758AbZCYB0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbZCYB0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbZCYB0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:26:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:51027 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZCYB0L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:26:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,416,1233561600"; 
   d="scan'208";a="500560207"
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-wimax <linux-wimax@intel.com>
Date: Tue, 24 Mar 2009 18:22:11 -0700
Subject: RE: [PATCH 25/61] wimax: struct device - replace bus_id with
 dev_name(), dev_set_name()
Thread-Topic: [PATCH 25/61] wimax: struct device - replace bus_id with
 dev_name(), dev_set_name()
Thread-Index: Acms4NMHeaQlVlcuTEiBs2JjdVYxewAB0yd6
Message-ID: <8F0C2E89B9AA20448D482EB589641EB326F9EC41@orsmsx507.amr.corp.intel.com>
References: <20090325001659.GA22461@kroah.com>,<1237940825-22904-25-git-send-email-gregkh@suse.de>
In-Reply-To: <1237940825-22904-25-git-send-email-gregkh@suse.de>
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


>From: Greg Kroah-Hartman [gregkh@suse.de]
>Subject: [PATCH 25/61] wimax: struct device - replace bus_id with dev_name(), dev_set_name()

This is posted already in net-next, (347707baa77d273d79258303e00200d40cf3b323)
