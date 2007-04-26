Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbXDZRm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbXDZRm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbXDZRm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:42:28 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:31442 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908AbXDZRm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cNgXxAPr49IS1W5yGf6+DF6G87PF7cEJRgVpWRJqsta8g9coHbpEsvQAv4hLtCRILqqnScPni3LnNjElHOQunDiSjGFaUy5rxw4D7BDEAoRgMCFC1l0ZmIyfRADYEARcAaF0W6Zv2+gvyyF4Zd+Mk07fimrf17AmRvhUYv9dY3Y=
Subject: Re: PROBLEM: Oops: 0002 [1] SMP
From: "Thiago M." =?ISO-8859-1?Q?Say=E3o?= <thiago.sayao@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <462FD515.6070106@redhat.com>
References: <1177379292.16380.16.camel@sayao-desktop>
	 <462E32C5.6020201@redhat.com> <1177539537.7180.3.camel@sayao-desktop>
	 <462FD515.6070106@redhat.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 26 Apr 2007 14:42:17 -0300
Message-Id: <1177609337.5496.1.camel@sayao-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just tested the memory again and some errors showed up. I swear that
they didn't appear the last time i tested. Sorry.

Thanks

Thiago.


On Wed, 2007-04-25 at 18:24 -0400, Chuck Ebbert wrote:
> Thiago M. Sayão wrote:
> > I also got this error yesterday which seems related:
> > 
> > Bad pagetable: 001d [1] SMP 
> > Bad pagetable: 0009 [2] SMP 
> > 
> 
> You may have a hardware problem. Did you test the memory?
> 

