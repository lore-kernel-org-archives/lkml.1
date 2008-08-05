Return-Path: <linux-kernel-owner+w=401wt.eu-S1764579AbYHEU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764579AbYHEU5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761340AbYHEU4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:56:43 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:33016 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbYHEU4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:56:42 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
Date: Tue, 5 Aug 2008 16:56:28 -0400
User-Agent: KMail/1.9.7
Cc: Cliffe <cliffe@ii.net>, Eric Paris <eparis@redhat.com>,
       malware-list@lists.printk.net, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <1217883616.27684.19.camel@localhost.localdomain> <4897C2A7.7020601@ii.net> <4897CC9C.2090906@schaufler-ca.com>
In-Reply-To: <4897CC9C.2090906@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051656.28231.paul.moore@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008 11:44:28 pm Casey Schaufler wrote:
> Cliffe wrote:
> > Other security schemes such as intrusion detection,
> > firewalls/netfilter, anti-malware, and application restrictions
> > (sandboxes such as jails or finer grained restrictions such as
> > AppArmor) could all register LSMs onto the stack.
>
> Stacking is easy for files. It's a real pain in the backside for UDP
> packets.

How is it any better/worse for UDP packets than files?

-- 
paul moore
linux @ hp
