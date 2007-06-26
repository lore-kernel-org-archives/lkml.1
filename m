Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbXFZVmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbXFZVmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 17:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbXFZVmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 17:42:12 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:20662 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbXFZVmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 17:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uwi/qIF34mo1tk/xDo1MzQL2Fzf+prTjnfDYZDmh9J9FrMD5sl5OeylwXSjr/XUbeMbqjcxWlXrz8ah8qKUwEWU8+h35goqKhtb74rySmvujMrsFqW8uatdC4sNLATGlnzHfzxZtgNwzxTLWxTEeJAmizqGYBA3EIEG5zdpeq9U=
Message-ID: <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com>
Date: Tue, 26 Jun 2007 22:42:08 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Shaohua Li" <shaohua.li@intel.com>
Subject: Re: New format Intel microcode...
Cc: jamagallon@ono.com, tigran@aivazian.fsnet.co.uk,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>
	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/03/07, Shaohua Li <shaohua.li@intel.com> wrote:
> On Thu, 2007-03-22 at 23:45 +0000, Daniel J Blueman wrote:
> > Hi Shao-hua,
> >
> > Is the tool you mentioned last June [1] available for splitting up the
> > old firmware files to the new format (eg
> > /lib/firmware/intel-ucode/06-0d-06), or are updates available from
> > Intel (or otherwise) in this new format?
> Yes, we are preparing the new format data files and maybe put it into a
> new website. We will announce it when it's ready.

It's been a while; is there any sign of the ucode updates being
available, especially in light of the C2D/Q incorrect TLB invalidation
+ recent ucode to fix this?

Thanks again,
  Daniel
-- 
Daniel J Blueman
