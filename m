Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZCIPHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZCIPHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZCIPHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:07:17 -0400
Received: from kroah.org ([198.145.64.141]:53407 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751062AbZCIPHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:07:15 -0400
Date: Mon, 9 Mar 2009 08:05:28 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, kay.sievers@vrfy.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: kobj refcounting weirdness
Message-ID: <20090309150528.GC7627@kroah.com>
References: <20090309063654.GB23137@ldl.fc.hp.com> <20090309150453.GB7627@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309150453.GB7627@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 08:04:53AM -0700, Greg KH wrote:
> On Mon, Mar 09, 2009 at 12:36:54AM -0600, Alex Chiang wrote:
> > 	- discover that e00000018cac2920 is still hanging around!
> 
> What do you mean by "rescan"?  And sure, if you create a new device, it
> could be allocated at the same location, that's what the slab allocators
> do, right?
> 
> Can you provide the full debug log that shows the problem?

Oh nevermind, you did that already, sorry, too early this morning...
