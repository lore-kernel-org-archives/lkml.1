Return-Path: <linux-kernel-owner+w=401wt.eu-S936461AbXGTR5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936461AbXGTR5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762445AbXGTR5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:57:35 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:20203 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762945AbXGTR5e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:57:34 -0400
Date: Fri, 20 Jul 2007 18:57:30 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] what should 'uptime' be on suspend?
Message-ID: <20070720175730.GB21550@deepthought>
References: <46A0210E.6010207@tmr.com> <20070720171729.GA19935@deepthought> <20070720104215.476f4cc1.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20070720104215.476f4cc1.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 10:42:15AM -0700, Randy Dunlap wrote:
> 
> man uptime:
> 	uptime - tell how long the system has been running
> 
> I claim that the system is not running when it is suspended,
> so the suspension time should not be included in uptime.
> 
 So, maybe I shouldn't have put corrected in inverted commas,
because this was a real correction and my previous usage was an
unintended side-effect of an error.

 Anyway, the current behaviour is known and I guess any attempt to
change it (e.g. to what Bill was expecting) won't be well received.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
