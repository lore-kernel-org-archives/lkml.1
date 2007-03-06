Return-Path: <linux-kernel-owner+w=401wt.eu-S1030320AbXCFJXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320AbXCFJXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030201AbXCFJXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:23:43 -0500
Received: from ip-svs-1.Informatik.Uni-Oldenburg.DE ([134.106.12.126]:48335
	"EHLO schlidder.svs.informatik.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030189AbXCFJXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:23:41 -0500
Date: Tue, 6 Mar 2007 10:23:39 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATA] Failed to set xfermode on LITE-ON LTR-48246S
Message-ID: <20070306092339.GA3803@titan.lahn.de>
Mail-Followup-To: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070227135838.GA4328@titan.lahn.de> <45EB9822.40300@gmail.com> <20070305103840.GA4381@titan.lahn.de> <45EC3B3F.7020509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EC3B3F.7020509@gmail.com>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun!

On Tue, Mar 06, 2007 at 12:46:07AM +0900, Tejun Heo wrote:
> Philipp Matthias Hahn wrote:
> > On Mon, Mar 05, 2007 at 01:10:10PM +0900, Tejun Heo wrote:
> > > * Does applying the attached patch over unpatched 2.6.20.1 fix the problem?
> >
> > Yes, it seems to fix it. (testes on top of the first patch mentioned
> > above, but witheout the second one.).
> > If I should test it as the sole patche, just mail me again please.
>
> Yeap, please test it on top of vanilla kernel to verify that the patch
> proper fixes the problem.

Yes, applying only this patch does fix the problem.
Thank you for your support.

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
