Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbZJAQ65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbZJAQ65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZJAQ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:58:57 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59234 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152AbZJAQ64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:58:56 -0400
Subject: Re: INFO: task journal:337 blocked for more than 120 seconds
From: Shirley Ma <mashirle@us.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mcao@us.ibm.com
In-Reply-To: <20091001132012.GA16975@amt.cnet>
References: <1254345112.8837.9.camel@localhost.localdomain>
	 <20091001132012.GA16975@amt.cnet>
Content-Type: text/plain
Date: Thu, 01 Oct 2009 09:58:56 -0700
Message-Id: <1254416336.6787.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-01 at 10:20 -0300, Marcelo Tosatti wrote:
> I've hit this in the past with ext3, mounting with data=writeback made
> it
> disappear.

Thanks. I will make a try. Someone should fix this.

Shirley

