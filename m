Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbZIIV2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbZIIV2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbZIIV2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:28:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbZIIV2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:28:05 -0400
Date: Wed, 9 Sep 2009 17:26:47 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Felix Blyakher <felixb@sgi.com>
Subject: Re: [Bug #13949] Cryptoloop stuck I/O issue on partition or
 loopback device
Message-ID: <20090909172647.29e52b47@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <200909082105.13124.rjw@sisk.pl>
References: <aIL9jMAYJnG.A.WjH.M3BpKB@chimera>
	<20090907152553.GA21768@infradead.org>
	<alpine.DEB.2.00.0909081029050.7636@p34.internal.lan>
	<200909082105.13124.rjw@sisk.pl>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 21:05:13 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday 08 September 2009, Justin Piszcz wrote:
> > Unsure how to edit on the kernel bugtracker but updating this thread to 
> > correct the subject.
> 
> I've changed the subject and moved the bug to I/O & storage.
> 

Should we just revert that barrier support in loopback, like I
suggested in bugzilla?
