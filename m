Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYHDSfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYHDSfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbYHDSfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:35:07 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:37639 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbYHDSfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:35:05 -0400
Message-ID: <48974BD3.6050503@linux.vnet.ibm.com>
Date: Tue, 05 Aug 2008 00:04:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Ryo Tsuruta <ryov@valinux.co.jp>, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org, Andrea Righi <righi.andrea@gmail.com>
Subject: Re: Too many I/O controller patches
References: <20080804.175126.193692178.ryov@valinux.co.jp> <1217870433.20260.101.camel@nimitz>
In-Reply-To: <1217870433.20260.101.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Mon, 2008-08-04 at 17:51 +0900, Ryo Tsuruta wrote:
>> This series of patches of dm-ioband now includes "The bio tracking mechanism,"
>> which has been posted individually to this mailing list.
>> This makes it easy for anybody to control the I/O bandwidth even when
>> the I/O is one of delayed-write requests.
> 
> During the Containers mini-summit at OLS, it was mentioned that there
> are at least *FOUR* of these I/O controllers floating around.  Have you
> talked to the other authors?  (I've cc'd at least one of them).
> 
> We obviously can't come to any kind of real consensus with people just
> tossing the same patches back and forth.

Ryo and Andrea - Naveen and Satoshi met up at OLS and discussed their approach.
It would be really nice to see an RFC, I know Andrea did work on this and
compared the approaches.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
