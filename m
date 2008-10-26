Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYJZIVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYJZIVu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 04:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYJZIVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 04:21:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57441 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYJZIVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 04:21:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=vzfiOw4ci+n/2d99Wr/HO4RDY94CrsGazDp6KEaMFWiZn0pn4JF5MaEzLgQswNh8Y
	u9p+0yLNAxkx16cMxCi2w==
Message-ID: <6599ad830810260121v1f0b2a0el28ae227ef107e185@mail.gmail.com>
Date: Sun, 26 Oct 2008 01:21:21 -0700
From: "Paul Menage" <menage@google.com>
To: "Dong-Jae Kang" <baramsori72@gmail.com>
Subject: Re: [Question] power management related with cgroup based resource management
Cc: "Matthew Garrett" <mjg@redhat.com>, balbir@linux.vnet.ibm.com,
       xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, corsetproject@googlegroups.com,
       "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
In-Reply-To: <2891419e0810260054p777a0602ndb4242628a7503d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2891419e0810201954q57087fc8ufcaa0e42f3ca99e2@mail.gmail.com>
	 <4901B5C2.9070108@linux.vnet.ibm.com>
	 <2891419e0810240524u746b731cjcbd127fa4204bd4d@mail.gmail.com>
	 <20081024232503.GA20140@srcf.ucam.org>
	 <2891419e0810250105j3e210df0pa3ba9665bd35313a@mail.gmail.com>
	 <6599ad830810250843u10f65917x3388276211e90316@mail.gmail.com>
	 <2891419e0810260054p777a0602ndb4242628a7503d2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2008 at 12:54 AM, Dong-Jae Kang <baramsori72@gmail.com> wrote:
>
> Under this trend,
> I just wonder whether the trend can be reflected to cgroup  based
> controllers or not.

Potentially, but I'm not sure that anyone is looking at the kind of
thing that you're describing.

Feel free to post a design for it if you have some concrete ideas.

Paul
