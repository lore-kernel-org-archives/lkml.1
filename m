Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0CBBpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:45:51 -0500
Received: from claw.goop.org ([74.207.240.146]:42250 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211Ab0CBBpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:45:49 -0500
Message-ID: <4B8C6DCC.1090207@goop.org>
Date: Mon, 01 Mar 2010 17:45:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Sheng Yang <sheng@linux.intel.com>
CC: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 6/7] xen: Unified checking for Xen of PV drivers
 to xenbus_register_frontend()
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-7-git-send-email-sheng@linux.intel.com>
In-Reply-To: <1267436315-24486-7-git-send-email-sheng@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2010 01:38 AM, Sheng Yang wrote:
> Signed-off-by: Sheng Yang<sheng@linux.intel.com>
>    

We covered this before; just change the tests so they run in PV domains 
so they don't crash on HVM+PV, and we can address these later.

     J
