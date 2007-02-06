Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbXBFKWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbXBFKWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 05:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXBFKWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 05:22:45 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:58273 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbXBFKWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 05:22:44 -0500
Message-ID: <45C856F1.7060403@in.ibm.com>
Date: Tue, 06 Feb 2007 15:52:41 +0530
From: Srinivasa Ds <srinivasa@in.ibm.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060918)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Srinivasa Ds <srinivasa@in.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org,
       jkenisto@us.ibm.com, anil.s.keshavamurthy@intel.com,
       prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [RFC] [PATCH] To list all active probes in the system
References: <45C85097.1000106@in.ibm.com> <20070206100607.GA10296@infradead.org>
In-Reply-To: <20070206100607.GA10296@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Feb 06, 2007 at 03:25:35PM +0530, Srinivasa Ds wrote:
>> Hi folks
>>
>>         I have developed a patch, that lists all active probes in the
>> system. I have done this through /proc interface. Currently list is
>> available under /proc/kprobes/list. Any suggestions for better place and
>> name??
> 
> /debug/kprobes/list? :)
> 
Good Idea, I will update my patch to use debugfs.
