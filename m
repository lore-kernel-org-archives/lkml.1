Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbYBNUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbYBNUHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:07:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYBNUGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:06:55 -0500
Received: from relay2.sgi.com ([192.48.171.30]:33132 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756041AbYBNUGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:06:54 -0500
Date: Thu, 14 Feb 2008 12:06:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>,
       Lee.Schermerhorn@hp.com, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, travis@sgi.com
Subject: Re: [RFC] bitmap relative operator for mempolicy extensions
In-Reply-To: <200802142102.41420.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0802141206100.1041@schroedinger.engr.sgi.com>
References: <20080214123528.25274.84387.sendpatchset@jackhammer.engr.sgi.com>
 <Pine.LNX.4.64.0802141126340.375@schroedinger.engr.sgi.com>
 <200802142102.41420.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2008, Andi Kleen wrote:

> You're saying the kernel should use these relative masks internally?

There is just some thoughts about this. Did not have time to look into the 
details. Mike?
 
> That means it would be impossible to run workloads that use the complete
> machine because you couldn't represent all nodes.

Not sure how they are addressing this.

