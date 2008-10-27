Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbYJ0Q2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbYJ0Q2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbYJ0Q2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:28:30 -0400
Received: from el-out-1112.google.com ([209.85.162.178]:40318 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYJ0Q22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jwSOgOzegpnc5nRVYxz58XyRdzJZFMroSrpzwzs98pyrsBuLAra22jY6896MK3IjBB
         kXBKB32Hrk1pC3l69q6I5KxeMwTpp+xWEubFOWT5obGWcc6uSDZK9gd8FyIAEmnchycl
         SHIeGk1PbjyRIDFaHGrnC6eDmgO3kH8mHGeTg=
Subject: Re: [RFC PATCHv2] printk: add the %pM, %p4, %p6 format specifiers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, anders@anduras.de,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225090765.3746.7.camel@johannes.berg>
References: <1224892008.3919.27.camel@johannes.berg>
	 <49035AF0.6040700@anduras.de> <1225008096.3478.3.camel@johannes.berg>
	 <20081026.010329.11475786.davem@davemloft.net>
	 <1225009308.3478.22.camel@johannes.berg>
	 <1225009822.3478.30.camel@johannes.berg>  <1225047674.10060.10.camel@brick>
	 (sfid-20081026_200122_320043_BFBB81CD)  <1225049591.3746.0.camel@johannes.berg>
	 <1225049929.10060.11.camel@brick>
	 (sfid-20081026_203902_019881_0F8064FC)  <1225050015.3746.2.camel@johannes.berg>
	 <1225060789.10060.13.camel@brick>  <1225067465.5672.1.camel@brick>
	 (sfid-20081027_013109_949949_342DF4F2)  <1225090765.3746.7.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 09:28:24 -0700
Message-Id: <1225124904.5440.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 07:59 +0100, Johannes Berg wrote:

> Also can you keep mac/ip address patches split up so we can use my
> version of the mac address patch (it's already well-tested)?
> 

Sure.  I'll build on top.

Harvey

