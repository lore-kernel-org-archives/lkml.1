Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbYFKWn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbYFKWn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYFKWnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:43:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:30382 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbYFKWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oxM7NQ85qpzbN3ObOl+E4UNgod53n0/+4d2YqKJGgtHQV5MpE8Wx7mo9fKOU+Txj+M
         T1yd41m0w6Ihl+6WYiV06zEk8hfbsI4RY/XrbU82Y3WwnYEtMgahJy87lTXFAgWEZubm
         gbMZ1lcFjaMrUl0QZ7rcdTUFe2dUZXjriJLsQ=
Message-ID: <86802c440806111543l476723abycbd6e1a33fecc6fa@mail.gmail.com>
Date: Wed, 11 Jun 2008 15:43:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: x86_64 boot hang when CONFIG_NUMA=n
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <20080611150503.858641f8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <15271334.1212702611270.JavaMail.oracle@acsmt304.oracle.com>
	 <86802c440806052241q90bb2dcmef9e98f2e24291e8@mail.gmail.com>
	 <20080606084217.d725fe04.randy.dunlap@oracle.com>
	 <86802c440806062055j3431ef7cn72a92f2e0264d6ac@mail.gmail.com>
	 <20080611150503.858641f8.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 3:05 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:

>>
>> can you check latest tip/master?
>
> It still hangs for me.
>
>> I tried that with your bad config on server test servers. all work well.
>
> Can (or did) you try 2.6.26-rc5?

just tried current linus's tree, your config works with my test servers.

can you bisect the tree to find patch that cause problem?

YH
