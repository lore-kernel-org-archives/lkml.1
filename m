Return-Path: <linux-kernel-owner+w=401wt.eu-S1765720AbYEBLDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765720AbYEBLDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759662AbYEBLDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:03:31 -0400
Received: from main.gmane.org ([80.91.229.2]:49048 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759549AbYEBLDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:03:30 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jesper Krogh <jesper@krogh.cc>
Subject: Re: Many open/close on same files yeilds 
Date: Fri, 2 May 2008 11:03:16 +0000 (UTC)
Message-ID: <loom.20080502T110150-114@post.gmane.org>
References: <4819E316.7000607@krogh.cc> <20080501223938.921f7cd2.akpm@linux-foundation.org> <481ACEC4.2040205@krogh.cc> <20080501051548.08bbbec1@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 90.184.13.46 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.14) Gecko/20080418 Ubuntu/7.10 (gutsy) Firefox/2.0.0.14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan <at> infradead.org> writes:
> On Fri, 02 May 2008 10:20:20 +0200
> Jesper Krogh <jesper <at> krogh.cc> wrote:
> > This is the only activity on the system .. so a load of 1 / 16cpus.
> 
> have you run fsck on the filesystem?

Yes.. the first thing i did was a forced fsck .. and it was clean. 

> (and it might be interesting to use dump the metadata to a file first
> to save the broken state for later analysis)

All 4.5TB? 

-- 
Jesper




