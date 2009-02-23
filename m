Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZBWSrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZBWSrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZBWSrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:47:11 -0500
Received: from os.eurotux.com ([216.75.63.6]:51216 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbZBWSrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:47:10 -0500
Date: Mon, 23 Feb 2009 18:47:02 +0000
From: Luciano Miguel Ferreira Rocha <luciano@eurotux.com>
To: Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ext4 locks under 2.6.28.3..6
Message-ID: <20090223184702.GA18463@bit.office.eurotux.com>
Mail-Followup-To: Luciano Miguel Ferreira Rocha <luciano@eurotux.com>,
	Theodore Tso <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>
References: <20090220103443.GA3641@bit.office.eurotux.com> <20090222011617.GD17066@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090222011617.GD17066@mit.edu>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 08:16:17PM -0500, Theodore Tso wrote:
> On Fri, Feb 20, 2009 at 10:34:43AM +0000, Luciano Miguel Ferreira Rocha wrote:
> > 
> > I've experienced intermittent locks on my ext4 filesystems under kernel
> > 2.6.28.3 till 2.6.28.6.
> 
> Are you still seeing the problem now that you're using 2.6.28.6?  It
> looks to me to be another case of bug

Yes, my report was after a lock just after upgrading to 2.6.28.6.

I'm currently on vacation till next week, so I haven't stressed my
system to see if it keeps locking up.

Regards,
Luciano Rocha

-- 
Luciano Rocha <luciano@eurotux.com>
Eurotux Informática, S.A. <http://www.eurotux.com/>
