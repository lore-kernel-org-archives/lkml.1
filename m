Return-Path: <linux-kernel-owner+w=401wt.eu-S2992961AbXEBJi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992961AbXEBJi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992966AbXEBJi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:38:59 -0400
Received: from ns2.suse.de ([195.135.220.15]:35625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992961AbXEBJi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:38:58 -0400
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Bill Irwin <bill.irwin@oracle.com>
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the 2G/2G split.
Date: Wed, 2 May 2007 11:38:43 +0200
User-Agent: KMail/1.9.6
Cc: Eric Dumazet <dada1@cosmosbay.com>, ebiederm@xmission.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070501557.815359000@suse.de> <46376210.6090200@cosmosbay.com> <20070501170046.GO26598@holomorphy.com>
In-Reply-To: <20070501170046.GO26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200705021138.43297.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2007 19:00:46 Bill Irwin wrote:
> Bill Irwin a écrit :
> >> as a stopgap measure, but I'm not all that interested in grabbing patch
> >> credits where others could do it easily enough. Either of the config
> >> alterations is fine by me as they now stand; maybe Eric Dumazet might
> >> care to do something like my suggestion at some point.
> 
> On Tue, May 01, 2007 at 05:51:44PM +0200, Eric Dumazet wrote:
> > Your patch is very fine Bill, please resubmit it with proper Signed-off-by
> > My first patch was a trivial reaction to try to keep alive 2G/2G split, 
> > yours is better for fine tuning.
> 
> I was hoping you would submit it as an update, but maybe adding your
> Signed-off-by: to my own will do.

Added thanks

-Andi

