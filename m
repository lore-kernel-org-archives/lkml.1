Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbYHTQE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbYHTQE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYHTQEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:04:51 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:39533 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbYHTQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:04:50 -0400
X-Greylist: delayed 2229 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2008 12:04:50 EDT
Message-ID: <48AC37DC.6060000@cfl.rr.com>
Date: Wed, 20 Aug 2008 11:27:24 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Martin Uecker <muecker@gwdg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: distributed shared memory / mmap
References: <1219238336.8097.29.camel@localhost>
In-Reply-To: <1219238336.8097.29.camel@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Uecker wrote:
> 
> Hi!
> 
> Is there any easy way to get shared memory between to
> processes on different machines? It seems possible using mmap
> on a file system like GFS on top of a distributed block device.
> 
> 

There is hardware available, designed just for this. Reflective Memory 
pci cards.

Mark
