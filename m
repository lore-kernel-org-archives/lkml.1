Return-Path: <linux-kernel-owner+w=401wt.eu-S1751686AbXCSSyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686AbXCSSyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXCSSyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:54:54 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:47320 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751686AbXCSSyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:54:53 -0400
Date: Mon, 19 Mar 2007 10:30:28 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Radoslaw Szkodzinski <astralstorm@gmail.com>
cc: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: is RSDL an "unfair" scheduler too?
In-Reply-To: <f44c5fdf0703190627x43427f26qaed948aed71847ad@mail.gmail.com>
Message-ID: <Pine.LNX.4.63.0703191027480.7769@qynat.qvtvafvgr.pbz>
References: <45FCD449.60303@argo.co.il>  <MDEHLPKNGKAHNMBLJOLKGEMBCFAC.davids@webmaster.com>
 <f44c5fdf0703190627x43427f26qaed948aed71847ad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Radoslaw Szkodzinski wrote:

>
>> Consider two servers,
> ^ ^ ^
>
> Well, aren't we discussing desktops?
> Server admins can fine-tune the rights and CPU quotas per group.
>

how many multi-user desktops are there? most desktops that I have seen run just 
about everything as a single user. I know that on mine, I don't want the 
updatedb process that runs as 'nobody' out of cron to have the same percentage 
of cpu as all the processes running as my userid.

David Lang
