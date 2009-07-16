Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbZGPT6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbZGPT6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933245AbZGPT6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:58:42 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:22379
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933116AbZGPT6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:58:40 -0400
Message-ID: <4A5F866E.3000907@panasas.com>
Date: Thu, 16 Jul 2009 22:58:38 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: david@lang.hm
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       James Smart <James.Smart@Emulex.Com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: deterministic scsi order with async scan
References: <alpine.DEB.1.10.0907151801040.9159@asgard>  <4A5F100E.9000107@panasas.com> <alpine.DEB.1.10.0907161017180.9159@asgard>  <4A5F723B.7070408@emulex.com>  <alpine.DEB.1.10.0907161143010.9159@asgard> <1247773155.6606.265.camel@mulgrave.site> <alpine.DEB.1.10.0907161245470.9159@asgard>
In-Reply-To: <alpine.DEB.1.10.0907161245470.9159@asgard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 19:58:41.0040 (UTC) FILETIME=[D0E60900:01CA064F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2009 10:48 PM, david@lang.hm wrote:
> 
> so if I don't use udev but do want the async detection my only option to 
> have it boot from card 1 instead of card 2 is to just keep rebooting the 
> machine until it guesses right?
> 

I guess sync detection would be faster then the reboots, on average ;-)

> David Lang
