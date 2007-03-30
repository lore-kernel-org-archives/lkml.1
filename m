Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbXC3T2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbXC3T2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbXC3T2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:28:24 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:50636 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbXC3T2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:28:23 -0400
Date: Fri, 30 Mar 2007 21:26:13 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Gerard Braad Jr." <me@gbraad.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: P5B-VM, problems with Memory remap and Linux (wont address more than 2.8Gb)
Message-ID: <20070330192613.GA4389@electric-eye.fr.zoreil.com>
References: <e8f45b9e0703291500y3b495fa4o9320fe1bf726189b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8f45b9e0703291500y3b495fa4o9320fe1bf726189b@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerard Braad Jr. <me@gbraad.nl> :
[...]
> Is there a solution available to make these systems work with 4Gb,
> full speed, a working R8169 (8111B) and no errors on IDE? If you need
> any debug information, please tell me what I need to do...

r8169 ?

Can you give a try to the patchkit available at:
http://www.fr.zoreil.com/linux/kernel/2.6.x/2.6.21-rc4/r8169-20070316

-- 
Ueimor
