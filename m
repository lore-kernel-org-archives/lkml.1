Return-Path: <linux-kernel-owner+w=401wt.eu-S1761966AbYC0WSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966AbYC0WSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759921AbYC0WSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:18:31 -0400
Received: from po-out-1718.google.com ([72.14.252.155]:37487 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759868AbYC0WSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Tjx9RIysO2FcscrRqV+6LzoouyvLxVWTWvE+oT3VyWUm4+50CGFVufq501RB5g82eVPQPF93d9O70grOkOjQWUHjZyFaEngAtAmjoug6Yrtc+ROcfk3VToFNq8zehkE6VFQZrEKiHrrFA+qa3nNl1fO4+kXr7U7tndmZ6yBZdnA=
Date: Thu, 27 Mar 2008 23:22:48 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, marcus@better.se,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bugme-new] [Bug 10326] New: inconsistent lock state in
	net_rx_action
Message-ID: <20080327222248.GA3596@ami.dom.local>
References: <bug-10326-10286@http.bugzilla.kernel.org/> <1206621014.8514.563.camel@twins> <20080327124928.GE2845@ami.dom.local> <200803272256.50454.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803272256.50454.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:56:49PM +0100, Rafael J. Wysocki wrote:
...
> I assume there will be a patch posted for this issue.  Correct?

I guess Peter should know the answer!

Jarek P.
