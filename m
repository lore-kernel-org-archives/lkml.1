Return-Path: <linux-kernel-owner+w=401wt.eu-S1754648AbYFBRCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbYFBRCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYFBRB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:01:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:59137 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbYFBRB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:01:57 -0400
Date: Mon, 2 Jun 2008 10:02:13 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Rick van Rein <rick@groengemak.nl>
cc: linux-kernel@vger.kernel.org
Subject: Re: Future Linux on Bistable Storage
In-Reply-To: <20080602125904.GA15129@phantom.vanrein.org>
Message-ID: <alpine.DEB.1.10.0806020953420.28080@asgard.lang.hm>
References: <20080602125904.GA15129@phantom.vanrein.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Rick van Rein wrote:

> Hello,
>
> Future generations of Linux are likely to run on machines with non-volatile
> memories based on bistable technologies.  This will save the energy of DRAM
> refresh cycles and avoid the mechanical problems related to hard disks.  The
> result is probably a computer with no distinction between disk and RAM.

unless there has been a breakthrough that I haven't heard about (always 
possible) I seriously doubt that this is the case.

the alternate technologies that I have heard about are either _far_ less 
dense then DRAM (similar to static ram) or require erasing in blocks 
(similar to flash). niether one is appropriate for a large, flat 
addressed memory architecture as you list below.

David Lang
