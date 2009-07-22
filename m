Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZGVBRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZGVBRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 21:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZGVBRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 21:17:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:29698 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZGVBRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 21:17:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,243,1246863600"; 
   d="scan'208";a="709877393"
Subject: Re: ACPI power meter driver?
From: Zhang Rui <rui.zhang@intel.com>
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090721234957.GB20171@plum>
References: <20090721234957.GB20171@plum>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 09:18:27 +0800
Message-Id: <1248225507.2670.2.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 07:49 +0800, Darrick J. Wong wrote:
> Hi everyone,
> 
> I noticed that section 10.4 of the ACPI 4.0 spec mentions exposing power meter
> hardware via the DSDT.

right.

>   Is anybody currently writing a Linux driver for that
> power meter interface?
> 
do you have an laptop with that implemented?
can you attach the acpidump output please? :)

thanks
rui


