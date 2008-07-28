Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbYG1Sr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbYG1Sr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYG1Srt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:47:49 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:39726 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753418AbYG1Srs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:47:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xxONe4ZTLy4TpQtjo2On64mc0yXo2iZk47+ylsikbSpZfbnYsAY+rg8gReDQQ1xo+xUiqxjNWFqVSQM/rUW9IMMjNZUKCjRDwKW71ohICcbk1DXTtQdEd+B2uK4ARDdyUDvgxnCZpzXT28BEofzz92twV/sD3K7cjSu3HgXnFhY=  ;
X-YMail-OSG: tbLXZLsVM1mBrjqAFNiYh4aWDiCfjxAgaz8V14BzWg3aXmcrCCDxcjcizk_mnsg0owHJLBuFxtmZHhD1xBq8.ptviHQ16iXoX8MW1dCt4uTH5c252Pm_Je2WPvTv4zsEDIE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] usb: move ehci reg def
Date: Mon, 28 Jul 2008 11:47:45 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200807231252.20371.yhlu.kernel@gmail.com> <20080728161102.GA18860@elte.hu> <20080728164747.GA31120@kroah.com>
In-Reply-To: <20080728164747.GA31120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281147.45612.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Greg KH wrote:
> No objections from me at all, I would like to see this code finaly get
> moved into the tree.

Yes ... with serial ports increasingly scarce, getting some use
out of this USB debug widget would be nice!

- dave

