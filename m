Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbZKWPtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbZKWPtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbZKWPts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:49:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:37786 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbZKWPts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:49:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xm6kMdJIaI1SwCF6/8HFpqKKQ2mcHxZ4/kP+AMBbigOK83tmTH770KKsH1TijhiRkE
         HEQVhM9D8bQQXqeZMoc/PTYMc8fw1zU6UDuQb1SjVJwR8r1eN8YG2ANw+dCLSHSm1uel
         hyuE/K4jGV7wc7WNYTJ98LsOT9r7IJFLz+qj0=
Date: Mon, 23 Nov 2009 23:50:34 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: linux-kernel@vger.kernel.org,
       Martin Habets <errandir_news@mph.eclipse.co.uk>
Subject: Re: PATCH [0/2] - CHECKSTACK: sparc-stack-size and formatting
Message-ID: <20091123155034.GF2412@hack>
References: <alpine.LRH.2.00.0911231148441.14263@pub1.ifh.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0911231148441.14263@pub1.ifh.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 12:01:00PM +0100, Patrick Boettcher wrote:
> Hi,
>
> I shamelessly stole the checkstack-script for a project of mine and now  
> want to contribute what I changed:
>
> 1) CHECKSTACK: sparc: fix regex to match all stacksizes

Please Cc sparc people for this, he should be David Miller, I think.


> 2) CHECKSTACK: simplify text-formatting for displaying the stacksize
>
> For 1): as there are no comments in the script as to why the regex was  
> limiting the detection of stacksizes to less 300 bytes and if I 
> understood it correctly, to a maximum of 1000, I simply removed it.

Please don't do this, write your change log for each patch please.


-- 
Live like a child, think like the god.
 
