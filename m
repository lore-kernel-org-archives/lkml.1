Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZGCGPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZGCGPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 02:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZGCGPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 02:15:04 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36828 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZGCGPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 02:15:03 -0400
Date: Fri, 3 Jul 2009 08:15:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: joseph.cihula@intel.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       arjan@linux.intel.com, hpa@zytor.com, andi@firstfloor.org,
       chrisw@sous-sol.org, jmorris@namei.org, jbeulich@novell.com,
       peterm@redhat.com, gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v6][PATCH 3/4] intel_txt: Intel(R) TXT Sx shutdown support
Message-ID: <20090703061502.GE2041@one.firstfloor.org>
References: <4A4ACA6B.4050705@intel.com> <200907030115.24552.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907030115.24552.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 01:15:23AM +0200, Rafael J. Wysocki wrote:
> Is there any documentation describing how ACPI sleeps states are supposed to
> work with the TXT hardware?

2.4.8.4 in http://download.intel.com/technology/security/downloads/315168.pdf

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
