Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbYDPWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbYDPWWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbYDPWWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:22:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:48162 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbYDPWWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:22:43 -0400
Subject: Re: 2.6.25-rc8-mm1 panic in rpaphp_register_slot()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Chiang <achiang@hp.com>, pbadari@us.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080416130343.a82702f0.akpm@linux-foundation.org>
References: <1207331616.5916.15.camel@badari-desktop>
	 <20080404180518.GA12642@ldl.fc.hp.com>
	 <1207340371.5916.23.camel@badari-desktop>
	 <20080404224227.GA31436@ldl.fc.hp.com>
	 <1207352128.5916.26.camel@badari-desktop>
	 <20080407234255.GA22514@ldl.fc.hp.com>
	 <20080416031712.GB3333@ldl.fc.hp.com> <1208331916.6958.270.camel@pasglop>
	 <20080416171127.GA18290@ldl.fc.hp.com>
	 <20080416130343.a82702f0.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 17 Apr 2008 08:16:25 +1000
Message-Id: <1208384185.6958.304.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-16 at 13:03 -0700, Andrew Morton wrote:
> 
> fwiw, http://userweb.kernel.org/~akpm/bh.gz (agains -rc9) contains all
> of
> -mm up to and including
> pci-hotplug-acpi-pci-slot-detection-driver.patch
> and is suitable for review/repair/etc.

Ok, I'll use that.

Cheers,
Ben.


