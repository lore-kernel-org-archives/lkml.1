Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbZBXVp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbZBXVp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 16:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756723AbZBXVpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 16:45:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:52346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbZBXVpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 16:45:45 -0500
Message-ID: <49A46A53.9060708@kernel.org>
Date: Tue, 24 Feb 2009 13:44:51 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Jourdan <tjourdan@interfaceconcept.com>,
       linux-kernel@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
       Peter Jones <pjones@redhat.com>
Subject: Re: [BUG] dmi_scan_machine uses uninitialized address on x86 / EFI
References: <342F93DAA55A4EE888FBD256CE6044F4@thje6600v> <49A462BD.7010205@zytor.com> <49A468E2.4040308@kernel.org> <49A469B5.7060601@zytor.com>
In-Reply-To: <49A469B5.7060601@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> should be ok for 2.6.29
> 
> Got a feel for what the impact of deferring it to .30 would be?
> 
Not sure, wonder if someone try 2.6.29-rc6 on EFI 32/64 sytem...

YH
