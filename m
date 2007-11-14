Return-Path: <linux-kernel-owner+w=401wt.eu-S1764158AbXKNXyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764158AbXKNXyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 18:54:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXKNXx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 18:53:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969AbXKNXxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 18:53:55 -0500
Message-ID: <473B8A92.8090409@redhat.com>
Date: Wed, 14 Nov 2007 18:53:54 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Repeated oopses with inode == 0xffffffff in 2.6.23
References: <473B89F9.7070204@redhat.com>
In-Reply-To: <473B89F9.7070204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2007 06:51 PM, Chuck Ebbert wrote:
> What does it mean when a pointer to an inode has a value of -1?
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=334181
> 
> 
> /usr/src/debug/kernel-2.6.22/linux-2.6.22.x86_64/block/ll_rw_blk.c:3139

Oops, this is 2.6.22.9...
