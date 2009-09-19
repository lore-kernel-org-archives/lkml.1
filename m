Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbZISQBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbZISQBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 12:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZISQBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 12:01:13 -0400
Received: from fifo99.com ([67.223.236.141]:47537 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbZISQBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 12:01:12 -0400
Subject: Re: [PATCH 06/20] mem_class: use minor as index instead of
 searching the array
From: Daniel Walker <dwalker@fifo99.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4AB4F602.20004@imap.cc>
References: <20090915181247.GA32167@kroah.com>
	 <1253041976-1111-6-git-send-email-gregkh@suse.de>
	 <1253043763.11643.358.camel@desktop>
	 <ac3eb2510909151246r59decb10pfb68fd5c0cb9a63a@mail.gmail.com>
	 <1253045229.11643.398.camel@desktop> <20090915202445.GC3411@suse.de>
	 <1253049491.11643.490.camel@desktop>  <20090915212019.GA6744@suse.de>
	 <1253050006.11643.492.camel@desktop>  <4AB4F602.20004@imap.cc>
Content-Type: text/plain
Date: Sat, 19 Sep 2009 09:01:12 -0700
Message-Id: <1253376072.6699.57.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-19 at 17:17 +0200, Tilman Schmidt wrote:
> Am 15.09.2009 23:26 schrieb Daniel Walker:
> > On Tue, 2009-09-15 at 14:20 -0700, Greg KH wrote:
> > 
> >> I'll gladly do that, it's trival for me to do so.
> >>
> > 
> > What about the other side ? The people who are sending the clean ups,
> > there time is valuable too..
> 
> Do such people really exist? Nobody ever sent a cleanup patch for any
> of the numerous checkpatch errors in drivers/isdn/gigaset. I only get
> complaints about them when I submit a patch that touches one of the
> affected lines.

Yeah, they do exist .. I've sent numerous checkpatch clean ups.

Daniel

