Return-Path: <linux-kernel-owner+w=401wt.eu-S2992861AbXEBGzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992861AbXEBGzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992841AbXEBGzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:55:16 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:33873 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992861AbXEBGzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:55:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=gc2VKI2yGgj6wYaIeRDXsae7mfwVNkAfx4zRi0I7l2rLY0O6isIowAK3sd8VzGO7dSRc2eUZchvqROVQI/lv/SSMjJB7AT5lNHvInYkjRZbbSvC1Vn5j8A6RfolBA1MOHq7nnA9BXqEFrecdfx+AdHt6DZf7gRVr5eIfY4j0FDs=  ;
X-YMail-OSG: _YcxpgMVM1mhEx09CW82kZN4ypBVWzRD46gArpeNhB57qBFZyBjQvWw_eW5QEHOSJNRq.im0sA--
Message-ID: <463835C7.3020902@yahoo.com.au>
Date: Wed, 02 May 2007 16:55:03 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: neilb@suse.de, akpm@linux-foundation.org, christopher.leech@intel.com,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 00/16] raid acceleration and asynchronous offload api
 for	2.6.22
References: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20070502060949.7066.357.stgit@dwillia2-linux.ch.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> I am pleased to release this latest spin of the raid acceleration
> patches for merge consideration.  This release aims to address all
> pending review items including MD bug fixes and async_tx api changes
> from Neil, and concerns on channel management from Chris and others.
> 
> Data integrity tests using home grown scripts and 'iozone -V' are
> passing.  I am open to suggestions for additional testing criteria.

Do you have performance numbers?

-- 
SUSE Labs, Novell Inc.
