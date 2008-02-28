Return-Path: <linux-kernel-owner+w=401wt.eu-S932630AbYB1Xdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbYB1Xdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758671AbYB1XdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:33:23 -0500
Received: from mail.globalsuite.net ([69.46.103.200]:51070 "HELO
	mail.globalsuite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756873AbYB1XdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:33:23 -0500
X-Greylist: delayed 106819 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2008 18:33:22 EST
X-AuditID: c0a8013c-ae558bb000007eb2-48-47c744c1c4f2
Date: Thu, 28 Feb 2008 15:10:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hidave.darkstar@gmail.com,
       akpm@linux-foundation.org, fzu@wemgehoertderstaat.de, ego@in.ibm.com,
       dipankar@in.ibm.com, niv@us.ibm.com, dvhltc@us.ibm.com
Subject: Re: [PATCH] Remove never-migrates assumption from rcu_process_callbacks()
Message-ID: <20080228231010.GB14104@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080228002110.GA20091@linux.vnet.ibm.com> <20080228195107.GA31203@linux.vnet.ibm.com> <20080228195309.GA29720@elte.hu> <20080228195454.GB29720@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228195454.GB29720@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 08:54:54PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > i've got the patch below queued up already - same thing, right?
> 
> oh, not the same thing - just looking very similar.
> 
> queued up the second patch too :-)

Thank you, Ingo!

/me goes back to analyzing the rcu-preempt code...

						Thanx, Paul
