Return-Path: <linux-kernel-owner+w=401wt.eu-S933649AbZJFWh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649AbZJFWh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933391AbZJFWhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:37:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:55069 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933344AbZJFWhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:37:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,515,1249282800"; 
   d="scan'208";a="557131869"
From: "Kay, Allen M" <allen.m.kay@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "matthew@wil.cx" <matthew@wil.cx>,
       "chris@sous-sol.org" <chris@sous-sol.org>
Date: Tue, 6 Oct 2009 15:37:15 -0700
Subject: RE: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
Thread-Topic: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding
Thread-Index: AcpG0Q+XQlG46d0WRkmLtmKVMLmlYQABG0Rw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA3E302254A@orsmsx505.amr.corp.intel.com>
References: <1254861226-18376-1-git-send-email-allen.m.kay@intel.com>
 <4ACBB8B0.9030102@goop.org>
 <57C9024A16AD2D4C97DC78E552063EA3E30224B7@orsmsx505.amr.corp.intel.com>
 <4ACBBF0E.60603@goop.org>
In-Reply-To: <4ACBBF0E.60603@goop.org>
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

Thanks!  I will re-spin my patch.

-----Original Message-----
From: Jeremy Fitzhardinge [mailto:jeremy@goop.org] 
Sent: Tuesday, October 06, 2009 3:05 PM
To: Kay, Allen M
Cc: linux-kernel@vger.kernel.org; linux-pci@vger.kernel.org; jbarnes@virtuousgeek.org; matthew@wil.cx; chris@sous-sol.org
Subject: Re: [PATCH ACS v4 1/1] Enabling PCI ACS P2P upstream forwarding

On 10/06/09 15:01, Kay, Allen M wrote:
> Better move to somewhere arch independent as I'm calling this in architectural independent PCI driver code.
>   

I'm prepping a patch for you now, to move it to xen/xen.h.

    J

