Return-Path: <linux-kernel-owner+w=401wt.eu-S1762997AbYF0SXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762997AbYF0SXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYF0SXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:23:34 -0400
Received: from outbound-mail-15.bluehost.com ([69.89.18.115]:39905 "HELO
	outbound-mail-15.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754619AbYF0SXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:23:33 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Ksummit-2008-discuss] Current List of Kernel Summit suggested topics from the discuss list
Date: Fri, 27 Jun 2008 11:23:29 -0700
User-Agent: KMail/1.9.9
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1214577710.3394.14.camel@localhost.localdomain> <200806271035.22856.jbarnes@virtuousgeek.org> <48652D5B.60108@zytor.com>
In-Reply-To: <48652D5B.60108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806271123.30222.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 27, 2008 11:11 am H. Peter Anvin wrote:
> Jesse Barnes wrote:
> > If we measure quality using bug metrics, things are pretty hard.
>
> One problem with any metric is that the metric becomes a driving factor
> in itself.  Consider the whole whitespace issue, for example.

Sure, but I don't think that's a reason to avoid metrics altogether.  We've 
already seen that purely qualitative discussions don't really get us 
anywhere.  For any discussion about kernel quality I think we have to:
  a) define our goals (no oopses?  fast bug fix turnaround?  whatever)
  b) define a way to measure progress against those goals
  c) periodically re-evaluate both

I think all of these are fairly difficult tasks, and any goal or metric we 
create will have problems, but does that mean we should just ignore quality?  
Or limit ourselves to our current situation where everyone has a different 
idea of what it means and whether we're achieving it?

Jesse
