Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbZGDALX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbZGDALX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 20:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbZGDALP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 20:11:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45466 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbZGDALP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 20:11:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC v6][PATCH 3/4] intel_txt: Intel(R) TXT Sx shutdown support
Date: Sat, 4 Jul 2009 02:11:34 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: joseph.cihula@intel.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       arjan@linux.intel.com, hpa@zytor.com, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
References: <4A4ACA6B.4050705@intel.com> <200907030115.24552.rjw@sisk.pl> <20090703061502.GE2041@one.firstfloor.org>
In-Reply-To: <20090703061502.GE2041@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907040211.36332.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009, Andi Kleen wrote:
> On Fri, Jul 03, 2009 at 01:15:23AM +0200, Rafael J. Wysocki wrote:
> > Is there any documentation describing how ACPI sleeps states are supposed to
> > work with the TXT hardware?
> 
> 2.4.8.4 in http://download.intel.com/technology/security/downloads/315168.pdf

Thanks!

Best,
Rafael
