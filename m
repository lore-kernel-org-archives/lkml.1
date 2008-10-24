Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYJXRuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYJXRuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYJXRt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:49:56 -0400
Received: from outbound-mail-32.bluehost.com ([69.89.18.152]:44117 "HELO
	outbound-mail-32.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753780AbYJXRty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:49:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=K57EWFhYG8V/1uwBHHJZ4CrPNMIt2GaAHn/jumdYu+GHV5Hg+Vx/eCsLsS+uGy7Di+qF6V2TFhTSvHI1DkAyQcBLMmSMu5RPSFrD0d0Lb1eglwQe+ub2TPxdAkQNWPpx;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] PCI hotplug printk format
Date: Fri, 24 Oct 2008 10:49:41 -0700
User-Agent: KMail/1.10.1 (Linux/2.6.26.5-45.fc9.x86_64; KDE/4.1.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> <20081023181455.336e5d03.randy.dunlap@oracle.com>
In-Reply-To: <20081023181455.336e5d03.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810241049.42017.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 23, 2008 6:14 pm Randy Dunlap wrote:
> I made this patch for linux-next, but now mainline has this same
> code/warning.
>
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix printk format warning:
>
> linux-next-20081023/drivers/pci/hotplug/acpiphp_ibm.c:207: warning: format
> '%08lx' expects type 'long unsigned int', but argument 3 has type 'long
> long unsigned int'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Spoke too soon, this one was already merged.

Jesse
