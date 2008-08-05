Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbYHEDvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbYHEDvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 23:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYHEDu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 23:50:59 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:49719
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751580AbYHEDu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 23:50:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMEAMhql0jLO4pc/2dsb2JhbAAIimalFA
X-IronPort-AV: E=Sophos;i="4.31,307,1215360000"; 
   d="scan'208";a="255274781"
Message-ID: <4897CCE2.90305@ii.net>
Date: Tue, 05 Aug 2008 11:45:38 +0800
From: Cliffe <cliffe@ii.net>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Casey Schaufler <casey@schaufler-ca.com>
CC: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access scanning
References: <1217883616.27684.19.camel@localhost.localdomain> <4897BFB4.9090309@schaufler-ca.com> <4897C2A7.7020601@ii.net> <4897CC9C.2090906@schaufler-ca.com>
In-Reply-To: <4897CC9C.2090906@schaufler-ca.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler wrote:
> Cliffe wrote:
>> Additional infrastructure would be necessary. Permissible security 
>> remains a item of contention. Perhaps I am naive but I think most 
>> LSMs could work based on accept/reject. Where every LSM must accept 
>> an action in order for it to be carried out.
>
> Please propose patches.
>
>> MHO,
>
> Oh, humility isn't all it's cracked up to be. Show us all up and
> write the code. I'm serious, I don't think there's anyone here who
> would object to a really good stacking scheme.

Ah, I'd love to give it a shot but I have this little PhD thesis and 
related LSM and tools I need to work on. I just thought I'd put my 5c in.

Cliffe.
