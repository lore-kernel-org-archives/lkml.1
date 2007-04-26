Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbXDZD37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbXDZD37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 23:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbXDZD37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 23:29:59 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:10994 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbXDZD36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 23:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=O1P6jHzCc1vOC6EaqPsSB6jt2XjFepShS6H052Wa9Dg56HEajdwKnerNnftOYj2ineKMLx9ajZ0/Msn5GhCYJjzzncLqmDpv6MOQptaeivRVTehtxNSmTBRc3FZSSxCLa2rohUVXw6TAph4AhY3prt7praa0kPzN1ercN7wznQU=
Subject: Re: PROBLEM: Oops: 0002 [1] SMP
From: "Thiago M." =?ISO-8859-1?Q?Say=E3o?= <thiago.sayao@gmail.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <462FD515.6070106@redhat.com>
References: <1177379292.16380.16.camel@sayao-desktop>
	 <462E32C5.6020201@redhat.com> <1177539537.7180.3.camel@sayao-desktop>
	 <462FD515.6070106@redhat.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 26 Apr 2007 00:29:52 -0300
Message-Id: <1177558192.12354.3.camel@sayao-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have also suspected this. memtest86 from test #1 to #10 showed an
error on test #3 once, so i removed the dimm, cleaned it and fixed it
again and run the tests two more times without any error. Is there any
other tool i could use to test the memory?

Thanks.

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

