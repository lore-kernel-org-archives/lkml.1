Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbXEQTkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbXEQTkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 15:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXEQTj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 15:39:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47928 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXEQTj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 15:39:56 -0400
Date: Thu, 17 May 2007 13:39:54 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>,
       Simon Arlott <simon@fire.lp0.eu>,
       James Bottomley <james.bottomley@steeleye.com>,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: Asynchronous scsi scanning
Message-ID: <20070517193953.GM10562@parisc-linux.org>
References: <20070515172905.GJ10562@parisc-linux.org> <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com> <20070516025121.GK10562@parisc-linux.org> <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com> <20070517172023.GL10562@parisc-linux.org> <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com> <20070517182414.GA12170@infradead.org> <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com> <20070517185115.GA13207@infradead.org> <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0705171204o5b25fafdm36d5970acf9119cd@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 12:34:40AM +0530, Satyam Sharma wrote:
> Hmmm, actually those other users could easily write and maintain
> a 20-line patch that does the wait for async scans thing for them
> using /proc/scsi/scsi in any case.

How about the three users who're bothered by this extra module being
built maintain a one-line patch to Kconfig and leave well enough alone?
