Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYEJSpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYEJSpc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 14:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYEJSpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 14:45:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37198 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYEJSpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 14:45:23 -0400
Date: Sat, 10 May 2008 12:45:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Douglas Gilbert <dougg@torque.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-Scsi <linux-scsi@vger.kernel.org>
Subject: Re: lsscsi is broken
Message-ID: <20080510184520.GM19219@parisc-linux.org>
References: <86802c440805091638q59031edbifa439344acf0c971@mail.gmail.com> <4825EAA0.5030305@torque.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4825EAA0.5030305@torque.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 10, 2008 at 02:34:08PM -0400, Douglas Gilbert wrote:
> Which version of lsscsi?
> [For example what is the output of 'lsscsi --version'.]
> 
> If it is not version 0.20 beta could you try it.
> See: http://sg.torque.net/scsi/lsscsi.html

Even if it isn't the latest version, we shouldn't've done anything to
break an older version.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
