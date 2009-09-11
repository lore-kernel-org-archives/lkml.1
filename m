Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZIKOcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZIKOcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZIKOb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:31:58 -0400
Received: from fifo99.com ([67.223.236.141]:48131 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZIKOb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:31:57 -0400
Subject: Re: [PATCH 8/8] fanotify: send events to userspace over socket
 reads
From: Daniel Walker <dwalker@fifo99.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, davem@davemloft.net, viro@zeniv.linux.org.uk,
       alan@linux.intel.com, hch@infradead.org
In-Reply-To: <1252678545.2305.4.camel@dhcp231-106.rdu.redhat.com>
References: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com>
	 <20090911052649.32359.18553.stgit@paris.rdu.redhat.com>
	 <1252678130.30578.848.camel@desktop>
	 <1252678545.2305.4.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 07:32:31 -0700
Message-Id: <1252679551.30578.857.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 10:15 -0400, Eric Paris wrote:

> I will look at all of the my 80+ character lines again.  This one in
> particular, I will not break up.  I might read a little too broadly in
> CodingStyle where it says the "exception to this is where exceeding 80
> columns significantly increases readability and does not hide
> information".

There is a point when longer lines get too long tho .. Maybe over 100 is
too long.. Where if your terminal only displays 80 characters , and the
text is way over 80 the lines just get wrapped and all the intended
readability goes out the window.

Daniel

