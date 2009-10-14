Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbZJNSpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbZJNSpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761295AbZJNSpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:45:49 -0400
Received: from lucidpixels.com ([75.144.35.66]:38570 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbZJNSpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:45:49 -0400
Date: Wed, 14 Oct 2009 14:45:12 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: System (motherboard/CPU?) emits high pitch noise when processor.ko
 is loaded.
Message-ID: <alpine.DEB.2.00.0910141443460.5747@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a finding I'd like to report:

   | |    <M>   Processor
   | |    <M>     Thermal Zone (NEW)

When the processor module is loaded, it works fine, no issues with the 
system etc but it emits a high pitch noise, without this module, the noise 
is absent, not sure what its doing but FYI.

Justin.
