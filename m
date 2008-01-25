Return-Path: <linux-kernel-owner+w=401wt.eu-S1761813AbYAYXOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813AbYAYXOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:14:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761650AbYAYXM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:12:57 -0500
Received: from 8bytes.org ([88.198.83.132]:50563 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761638AbYAYXMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:12:54 -0500
X-Greylist: delayed 1515 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jan 2008 18:12:53 EST
Date: Fri, 25 Jan 2008 23:47:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Joerg Roedel <joerg.roedel@amd.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: Re: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging in AMD Fam16 CPUs
Message-ID: <20080125224737.GA21476@8bytes.org>
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com> <479A5589.7030201@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479A5589.7030201@codemonkey.ws>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 03:32:57PM -0600, Anthony Liguori wrote:

> A quick sniff test and things look pretty good.  I was able to start 
> running the install CDs for 32-bit and 64-bit Ubuntu, 32-bit OpenSuSE, 
> 64-bit Fedora, and 32-bit Win2k8.  I'll do a more thorough run of 
> kvm-test on Monday when I have a better connection to my machine.

Great. We will do more tests too next week. Life migration is completly
untested for now. SMP guests worked also fine with this patches.

> Nice work!

Thanks :-)

Joerg
