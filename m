Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab0BLUy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 15:54:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:65270 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab0BLUy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 15:54:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,463,1262592000"; 
   d="scan'208";a="772464799"
Date: Fri, 12 Feb 2010 12:54:23 -0800 (Pacific Standard Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: David Miller <davem@davemloft.net>
cc: "mjg@redhat.com" <mjg@redhat.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       bruce.w.allan@intel.com
Subject: Re: [PATCH 1/2] e1000e: Only disable ASPM on 82573L devices
In-Reply-To: <20100212.123917.109973609.davem@davemloft.net>
Message-ID: <alpine.WNT.2.00.1002121249480.5328@jbrandeb-desk1.amr.corp.intel.com>
References: <1265756630-8093-1-git-send-email-mjg@redhat.com> <20100212.123917.109973609.davem@davemloft.net>
User-Agent: Alpine 2.00 (WNT 1167 2008-08-23)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: amrjbrandeb@imapmail.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 12 Feb 2010, David Miller wrote:
> Intel folks, are you looking at these patches?

Hi Dave, yes we're looking at them but due to Bruce being out, we need to 
wait until next week to reply.  If you can wait, we'll make sure they come 
through Jeff or receive comments after full review.

It's a bit of a scary area to mess with as there were lots of ASPM related 
bugs in the hardware in this hardware generation (system chipsets and 
82573).
