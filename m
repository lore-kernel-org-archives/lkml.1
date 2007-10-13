Return-Path: <linux-kernel-owner+w=401wt.eu-S1761801AbXJMA6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801AbXJMA6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 20:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761439AbXJMA6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 20:58:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbXJMA6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 20:58:34 -0400
Date: Fri, 12 Oct 2007 20:58:19 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Correct filenames in comments.
Message-ID: <20071013005819.GB18760@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, tglx@linutronix.de,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <20071013004332.GA18760@redhat.com> <20071012174950.7cf2e0b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012174950.7cf2e0b9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 05:49:50PM -0700, Andrew Morton wrote:
 > On Fri, 12 Oct 2007 20:43:32 -0400
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > I never really understood the motivation behind putting the filename
 > > in a comment, but this fixes up a bunch of them that are now wrong
 > > post-merge.
 > 
 > Let's just delete them.

That works for me too. I'll send another diff.

	Dave

-- 
http://www.codemonkey.org.uk
