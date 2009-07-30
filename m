Return-Path: <linux-kernel-owner+w=401wt.eu-S1751517AbZG3JFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbZG3JFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 05:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbZG3JFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 05:05:37 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:23102
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751037AbZG3JFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 05:05:36 -0400
Message-ID: <4A71625C.8060707@panasas.com>
Date: Thu, 30 Jul 2009 12:05:32 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: consistent use of __u8 in scsi/scsi.h
References: <20090729111114.GA15239@redhat.com> <1248875763.3900.1.camel@mulgrave.site> <4A705831.3010002@panasas.com> <20090729205626.GA3592@redhat.com>
In-Reply-To: <20090729205626.GA3592@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2009 09:05:34.0909 (UTC) FILETIME=[E5ED76D0:01CA10F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2009 11:56 PM, Michael S. Tsirkin wrote:
> On Wed, Jul 29, 2009 at 05:09:53PM +0300, Boaz Harrosh wrote:
>> TODO:
>> * Fix up Kernel headers by complying to check_headers
> 
> This is accomplished by applying the following on top
> of my previous patch:
> 

This is not enough. The same should be done to the other 3 
include/scsi headers I mentioned and export them.

<snip>

Boaz
