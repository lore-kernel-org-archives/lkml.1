Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbYBMDXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbYBMDXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbYBMDXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:23:03 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47495 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752092AbYBMDXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:23:01 -0500
Date: Tue, 12 Feb 2008 21:22:58 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] mempolicy: convert MPOL constants to enum
Message-Id: <20080212212258.7170bc10.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802121911040.3418@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<1202861432.4974.29.camel@localhost>
	<20080212183158.3ff4ccd5.pj@sgi.com>
	<Pine.LNX.4.64.0802121702431.11628@schroedinger.engr.sgi.com>
	<20080212193229.edbff05a.pj@sgi.com>
	<alpine.DEB.1.00.0802121755400.23110@chino.kir.corp.google.com>
	<20080212202201.a534cef8.pj@sgi.com>
	<alpine.DEB.1.00.0802121832520.29792@chino.kir.corp.google.com>
	<20080212205944.86ab2dc7.pj@sgi.com>
	<alpine.DEB.1.00.0802121911040.3418@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> That doesn't logically follow because the aggregate of the mode and the 
> optional flags _are_ the policy itself.

I give up ... I still don't agree, but that's ok.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
