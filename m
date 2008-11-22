Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYKVDyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYKVDyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYKVDyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:54:06 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54097 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbYKVDyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:54:04 -0500
Date: Fri, 21 Nov 2008 22:46:59 -0500 (EST)
From: Jeff Arnold <jbarnold@MIT.EDU>
To: Nikanth Karthikesan <knikanth@suse.de>
cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, davem@davemloft.net,
       mhiramat@redhat.com, contact@ksplice.com, jbarnold@ksplice.com,
       tabbott@ksplice.com, wdaher@ksplice.com, andersk@ksplice.com
Subject: Re: [RFC] kreplace: Rebootless kernel updates
In-Reply-To: <200811211720.26394.knikanth@suse.de>
Message-ID: <alpine.DEB.2.00.0811211303460.24014@vinegar-pot.mit.edu>
References: <200811211720.26394.knikanth@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> [kreplace] is currently a x86_64 only _hack_

The point of Ksplice is to be a hot update system that isn't a hack.  
Ksplice is quite far along at this point; it implements many safety and 
automation features that kreplace doesn't address.  Is there something in 
particular that discouraged you from using Ksplice?

Jeff Arnold
jbarnold@mit.edu
