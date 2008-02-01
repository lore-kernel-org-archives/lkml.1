Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbYBAVYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbYBAVYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757785AbYBAVYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:24:11 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:36633 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751497AbYBAVYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:24:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SpUSxO55QeA+gxWGmfd0cDdVVNdNL1Fz2xIqgK2FL88R5BqSXpHKABD2b7awnrmbknGPCY9KFwXPD4oTsVq09y2kH8w0+rMz3Kst0KvR2/PzALcBLB+GY50fGS6B7P+LkpKh3Ixt8Xa6+LIfRkNEAF+bHMcFAkrKYRY3YTy3vCI=  ;
X-YMail-OSG: yJ59y40VM1kZ7uWw_y03hrzPjc6TMFQgarDWsWehKC7Y.LmPlJr9pQW6h9OSU4ii_YT_30hvKw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Removing dev.power.power_state (WAS: Feature Removals for 2.6.25)
Date: Fri, 1 Feb 2008 13:24:07 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Harvey.Harrison@gmail.com
References: <Pine.LNX.4.44L0.0802011019370.3839-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802011019370.3839-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011324.07760.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008, Alan Stern wrote:
>
> I can look at the USB and SCSI stuff.  It shouldn't be all that bad.  
> The userspace interface has been gone for quite some time now, and most 
> of the remaining uses of that field are write-only.

It's that "most" which can make trouble.  :)

- Dave
