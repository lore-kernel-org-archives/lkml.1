Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbYJURhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbYJURhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYJURg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:36:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbYJURg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:36:57 -0400
Date: Tue, 21 Oct 2008 18:35:52 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <mauelshagen@redhat.com>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Kazuo Ito <ito.kazuo@oss.ntt.co.jp>,
       "Martin K. Petersen" <martin.petersen@oracle.com>, stable@kernel.org
Subject: Re: [stable] [git pull] Additional device-mapper patches for 2.6.28
Message-ID: <20081021173552.GK2810@agk.fab.redhat.com>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org,
	Heinz Mauelshagen <mauelshagen@redhat.com>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Milan Broz <mbroz@redhat.com>, Kazuo Ito <ito.kazuo@oss.ntt.co.jp>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable@kernel.org
References: <20081021165901.GO5098@agk.fab.redhat.com> <20081021170436.GA25030@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021170436.GA25030@kroah.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 10:04:36AM -0700, Greg KH wrote:
> Hm, as you copied stable@kernel.org, does that mean that some of these
> are applicable to -stable releases?
 
Yes - the ones with 'Cc: stable@kernel.org' in the changelog from which
I generated the Cc list.  I've sent them separately.

Alasdair
-- 
agk@redhat.com
