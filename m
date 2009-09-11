Return-Path: <linux-kernel-owner+w=401wt.eu-S1751780AbZIKERS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbZIKERS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 00:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbZIKERR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 00:17:17 -0400
Received: from smtp107.prem.mail.sp1.yahoo.com ([98.136.44.62]:47242 "HELO
	smtp107.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750859AbZIKERR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 00:17:17 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: pFJwnC8VM1mE0HViQqXe7xCfA5wmREsaAP41OosMWWtwmIRRqD9zumUS9MxSUoJkHzQFNwIRaUeeVXaNNABkKAeeWK5Ueyhz16GsdtyQ1t7W87Mh7AhJHZo6Yxs9JLLnJZf9w.Qh4et9W2rB11u.dAKk6fmD5WMkFMYIDYl2w77.2zrziYJcyR4IIF4Cg0Nsq1za1NdlZ2FfLWs3r5d.ae6vjB.cbmFODasa4awvGeOWdc3UHWNl0u.oog0.V1TM5sa9djPTVXzxXgtduCp_dd7mDs0_Ke3vGIhhbTd8
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AA9CF46.1050908@schaufler-ca.com>
Date: Thu, 10 Sep 2009 21:17:10 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/3] sysfs: Add labeling support for sysfs
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov> <1252002358-6612-4-git-send-email-dpquigl@tycho.nsa.gov> <alpine.LRH.2.00.0909071147100.2538@tundra.namei.org> <1252520737.13634.833.camel@moss-pluto.epoch.ncsc.mil> <alpine.LRH.2.00.0909101040460.30636@tundra.namei.org> <20090910030121.GA32239@suse.de>
In-Reply-To: <20090910030121.GA32239@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Sep 10, 2009 at 10:40:59AM +1000, James Morris wrote:
>   
>> Thanks, all applied to
>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
>>     
>
> Um, wait, what about the sysfs maintainer's review?  :)
>
> I also want to see Casey agree with this as well.
>   

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

As I said before, I still want to see general xattr support,
but I suppose that can wait for a later date. I've held this
up long enough.


> thanks,
>
> greg k-h
>
>
>   

