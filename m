Return-Path: <linux-kernel-owner+w=401wt.eu-S1030522AbXAYTgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030522AbXAYTgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 14:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXAYTgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 14:36:53 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:45048 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030522AbXAYTgw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 14:36:52 -0500
Date: Thu, 25 Jan 2007 19:36:44 +0000
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.18-stable release plans?
Message-ID: <20070125193644.GA12624@deepthought>
References: <20070125010020.GB26654@deepthought> <486377.64357.qm@web52903.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <486377.64357.qm@web52903.mail.yahoo.com>
User-Agent: Mutt/1.5.12-2006-07-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 09:16:04AM +0000, Chris Rankin wrote:
> 
> But anyway - can someone please tell me what "Eeek! page_mapcount(page) went negative! (-1)" is
> *really* saying/implying? Because I am currently translating this as "I WANT TO EAT YOUR
> FILESYSTEMS".
> 
 I can't, but Dave Jones had a similar problem earlier this month,
archived at http://uwsg.iu.edu/hypermail/linux/kernel/0701.0/1822.html
which I think is a followup from
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg105370.html
 - and seems to be a possible hardware failure (bulging capacitors)
becoming apparent under load.

Ken
-- 
das eine Mal als Tragödie, das andere Mal als Farce
