Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbZL2WBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbZL2WBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752106AbZL2WBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:01:00 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:58387 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZL2WA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:00:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=EPJ3uCTwKj8eIoIlC68klbhtkoTa9eRY0BfbuV64Mp0kBWwD8PTNvuUMjCZE5G0VCa
         LOak3TUFdZwTevVFPnkRmz4Gr6jVm7tq/vm5nAMkuJRfvUWP1Fxo/XTwnMdeGjH0NsoJ
         1KGdbuI0mYfYKOoVRCUTZuiBq9uxExEjpG0WA=
Date: Tue, 29 Dec 2009 23:00:51 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.33-rc2: Reported regressions 2.6.31 -> 2.6.32
Message-ID: <20091229220051.GA3185@del.dom.local>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera>
 <4B3A5BC2.10207@gmail.com>
 <4B3A6CB1.3030305@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B3A6CB1.3030305@freemail.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 29, 2009 at 09:55:13PM +0100, Németh Márton wrote:
> Jarek Poplawski wrote:
> > Rafael J. Wysocki wrote, On 12/29/2009 04:26 PM:
> > 
> > ...
> >> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14794
> >> Subject		: IP address assigned by DHCP is dropped after ~40 seconds
> >> Submitter	: Márton Németh <nm127@freemail.hu>
> >> Date		: 2009-12-13 08:59 (17 days old)
> >>
> > 
> > 
> > IMHO this bug might be considered as fixed by updating a userspace tool
> > (KNetworkManager) - unless somebody wants to seek for the exact reason...
> 
> For me (I am the reporter) the problem was solved by upgrading a userspace
> tool, so I think the bug filed against the kernel can be closed marking
> that this was not really a kernel bug.

Yes, let's hope author(s) of KNetworkManager would let us know if they
had to change it because of the kernel error.

Regards,
Jarek P.
