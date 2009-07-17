Return-Path: <linux-kernel-owner+w=401wt.eu-S934133AbZGQG2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbZGQG2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 02:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934121AbZGQG2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 02:28:00 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35269 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934107AbZGQG2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 02:28:00 -0400
Date: Fri, 17 Jul 2009 11:57:47 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: PTY bug in 2.6.31-rc3?
Message-ID: <20090717062747.GA18331@skywalker>
References: <E1MRTib-0002Cw-T0@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MRTib-0002Cw-T0@closure.thunk.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 12:22:01PM -0400, Theodore Ts'o wrote:
> Hey Alan,
> 
> I'm running 2.6.31-rc3, and twice now over about 36 hours all
> pseudo-tty's have stopped working on my system.   Everything else works;
> I can fire up gui applications, but starting any new programs that use
> pty's will hang.   The only fix seems to be to reboot the system.
> 
> I think I remember seeing a similar report, but I thought you said it
> had been fixed in -rc3 --- does this ring a bell?
> 

One problem is already fixed upstream. I have reported that here
http://thread.gmane.org/gmane.linux.kernel/865691. I still have
another bug which i explained in the last email of the above thread

-aneesh
