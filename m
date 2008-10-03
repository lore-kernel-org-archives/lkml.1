Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYJCVa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYJCVa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 17:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYJCVaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 17:30:20 -0400
Received: from outbound-mail-140.bluehost.com ([67.222.39.30]:39361 "HELO
	outbound-mail-140.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752623AbYJCVaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:30:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=GTyhTJvjEdsxHZ3XjpZFkKEpKKhLIuL6DvEJJXsM5uVagvKRWMGY7Sj5HIH1zhO53bbQh15nh0QJCyR7AdxizjwQ/Z7DAOsmJPy9Q6q+/Lo/kcwWLXXVva4KO4mQnv8U;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH 02/12] On Tue, 23 Sep 2008, David Miller wrote:
Date: Fri, 3 Oct 2008 14:29:20 -0700
User-Agent: KMail/1.9.10
Cc: jesse.brandeburg@intel.com, linux-kernel@vger.kernel.org,
       linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <200810021523.45884.jbarnes@virtuousgeek.org> <20081003.134634.240211201.davem@davemloft.net>
In-Reply-To: <20081003.134634.240211201.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031429.22598.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 3, 2008 1:46 pm David Miller wrote:
> From: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date: Thu, 2 Oct 2008 15:23:43 -0700
>
> > Ping DaveM.  Does this look ok?  What else would we need for you to
> > remove your range checking from sparc?
>
> Sorry, I've been in Paris for more than a week otherwise
> I would have looked at this already.
>
> I fly home tomorrow, so I'll try to look at it by next
> week.

Ok, thanks.  You'll have to check Linus' tree for sanity though, he just 
merged a variant on my patch for 2.6.27.  See 
b5ff7df3df9efab511244d5a299fce706c71af48 and yell if it broke something for 
you.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
