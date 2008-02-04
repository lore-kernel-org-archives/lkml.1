Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYBDPsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYBDPsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYBDPsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:48:31 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:6422 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbYBDPsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:48:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rrvK7iLMwJxGWROjJgAnp2nk/sjT6/HBlRqj/3t3ZGUrHpA3H8SNgpXMaPSN01J2KUyAqyoZw2ApPO5ET3q0PH1VgjhFOadXeHbYFv72Pbc0peX0ZVeXxZap9sCDJVmTvURQqukqfgo53p+Qu61ZvhkEYO+HkQRPqF9SgyXl0NA=
Message-ID: <b6a2187b0802040748s5b4d587ap90602d2b4383e122@mail.gmail.com>
Date: Mon, 4 Feb 2008 23:48:27 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Commit f06e4ec breaks vmware
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       petr@vandrovec.name, "Glauber de Oliveira Costa" <gcosta@redhat.com>
In-Reply-To: <20080204153631.GA30943@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
	 <20080204115144.GA17850@elte.hu>
	 <b6a2187b0802040601s76222435t306aef2059cbbb2b@mail.gmail.com>
	 <20080204145311.GB13154@elte.hu>
	 <b6a2187b0802040730y44580594i56b26ed0fcb8292e@mail.gmail.com>
	 <20080204153631.GA30943@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 4, 2008 11:36 PM, Ingo Molnar <mingo@elte.hu> wrote:
> great! I've added:
> you did all the hard work by bisecting it down so fast - fixing it was
> easy :)

Ingo,

Took me the whole of Friday night. I thought it was just me and my
vmware, so I didn't bother reporting until Jan reported it. Worried
that someone might just shoot me down for reporting a vmware problem
as it booted fine with kvm, and on X60s.

Thanks again for fixing it. Now I can test latest linux git version on
vmware again (host is running linux as well).

Jeff.
