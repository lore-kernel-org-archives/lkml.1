Return-Path: <linux-kernel-owner+w=401wt.eu-S1766828AbXEBRLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766828AbXEBRLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766831AbXEBRLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:11:53 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:4233 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766828AbXEBRLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:11:51 -0400
Date: Wed, 2 May 2007 21:12:15 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: regression on quad Xeon: no SCSI-disks
Message-ID: <20070502211215.A19444@jurassic.park.msu.ru>
References: <20070501142431.GA11667@erig.dyndns.org> <46376474.8090505@redhat.com> <20070502144716.GA11061@erig.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20070502144716.GA11061@erig.dyndns.org>; from Wolfgang.Erig@gmx.de on Wed, May 02, 2007 at 04:47:16PM +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 04:47:16PM +0200, Wolfgang Erig wrote:
> On Tue, May 01, 2007 at 12:01:56PM -0400, Chuck Ebbert wrote:
> > Output from kernel with CONFIG_PCI_DEBUG could be useful.
> > 
> Linux version 2.6.21-gde46c337 (erig@pippin) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #3 SMP Wed May 2 08:39:55 CEST 2007

Still no clues. Could you post 'lspci -vvv', 'cat /proc/ioports' and
'cat /proc/iomem' outputs from working kernel?

Ivan.
