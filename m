Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbYFYVNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbYFYVNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYFYVNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:13:08 -0400
Received: from outbound-mail-12.bluehost.com ([69.89.18.112]:45145 "HELO
	outbound-mail-12.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751386AbYFYVNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:13:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci: VT3336 can't do MSI either
Date: Wed, 25 Jun 2008 14:12:53 -0700
User-Agent: KMail/1.9.9
Cc: Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz
References: <48608792.7090909@kernel.org> <20080623225302.ab7b35de.akpm@linux-foundation.org>
In-Reply-To: <20080623225302.ab7b35de.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251412.53453.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 23, 2008 10:53 pm Andrew Morton wrote:
> On Tue, 24 Jun 2008 14:35:14 +0900 Tejun Heo <tj@kernel.org> wrote:
> > It seems VT3336 can't do msi either as with its bro 3351.  Disable it.
> > Reported in the following SUSE bug.
> >
> >   https://bugzilla.novell.com/show_bug.cgi?id=300001
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
>
> (argh.  Is that permanent(ish)?)
>
> > ---
> > Anyone interested in queuing this for -rc8?  Thanks.
>
> Strictly a Jesse thing I guess, but I can do it ujnless there be
> objections.

Yeah, no objections here.  Thanks.

Jesse
