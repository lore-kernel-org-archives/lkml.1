Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYGaWB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYGaWB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759156AbYGaWBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:01:04 -0400
Received: from outbound-mail-151.bluehost.com ([67.222.39.31]:51416 "HELO
	outbound-mail-151.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759422AbYGaWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:01:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=p4zQWmAUmLIpHgz1pWIARJkYQ3dLsgL1P7yzbfSup3wlNp+Eni5FRS27OBpfrCNP0K7NUEP6NWct+cdpZZvIjnGq6Pd8NNWbx3DODQB339zYiNaDxJXjS3bvYfzB81Fz;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] Fwd: [PATCH] PCI: Limit VPD length for Broadcom 5708S
Date: Thu, 31 Jul 2008 15:00:58 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807311319.24549.jbarnes@virtuousgeek.org> <20080731214802.GA4817@kroah.com>
In-Reply-To: <20080731214802.GA4817@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311500.58887.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2008 2:48 pm Greg KH wrote:
> On Thu, Jul 31, 2008 at 01:19:24PM -0700, Jesse Barnes wrote:
> > Just applied this to my for-linus branch.  It's a crash fixer so it
> > should probably go into -stable too.
>
> As per Documentation/stable_kernel_rules.txt, an easy way to do this
> automatically is:
> 	- If the stable@kernel.org address is added to a patch, when it
> 	  goes into Linus's tree it will automatically be emailed to the
> 	  stable team.
>
> So just add "Cc: stable <stable@kernel.org>" to the signed-off-by area
> and we will know to apply it when Linus picks it up.  Otherwise we have
> to hunt through the tree, which is a pain at times :)

Oh hey there's even a doc that mentions that, neat. :)

Thanks,
Jesse
