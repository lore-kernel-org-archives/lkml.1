Return-Path: <linux-kernel-owner+w=401wt.eu-S1161129AbXAZSLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161129AbXAZSLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161131AbXAZSLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:11:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:50199 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161129AbXAZSLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:11:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=jPguOuLcXT6f54GHbssocHTqdpe8YOXNpkTIyZvV65tFmzbFWx4gGQ8sdgbd5EuO3/gjk/xesElujdXMe5Er4yJQSf2j7owEmSbZ0vn9JwjYF0vf8Yncm/hl90kuweuWUljX9suxWMRMSOx5BVWN/5BEAOUGHiMTSO5bb+OolnI=
Date: Tue, 26 Dec 2006 20:10:03 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Jose Goncalves <jose.goncalves@inov.pt>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Oops on serial access on kernel 2.6.16.38
Message-ID: <20061226201003.GA2990@slug>
References: <45BA2341.40008@inov.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45BA2341.40008@inov.pt>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 03:50:25PM +0000, Jose Goncalves wrote:
> I'm having a problem with the latest 2.6.16 kernel (I've found the
> problem on 2.6.16.37 and 2.6.16.38). I have a application that retreives
> data from a GPS connected on a serial port. From time to time a get a
> kernel Oops, like this:
> 
Could you send your .config?

Regards,
Frederik
