Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbXIYHdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbXIYHdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbXIYHc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:32:59 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:54714 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbXIYHc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R1VLyz3AvgFw0J2HsV+TUukXu9Y2A0Y7daC5PK/x7LtL2jIorOoqdtnp9r7r41XJdVrEwM8W8XY+jAx2AqFX3YXXqxtkcU102JlhENB5L0OxsZq4OD0I2//wiwstUOZonfE2dglaQ7svYnkoJEaW8xabKXbzWUfp0D0bbgLXFF4=
Message-ID: <64bb37e0709250032j4d2e23c3iccc48fe2e647cbd4@mail.gmail.com>
Date: Tue, 25 Sep 2007 09:32:57 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.23-rc7-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <1190665512.4035.247.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	 <64bb37e0709241207q1c188b35ua485a06776ed4bf2@mail.gmail.com>
	 <20070924123450.f9e54d3d.akpm@linux-foundation.org>
	 <1190665512.4035.247.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> Can your check whether 2.6.23-rc7 +
> http://tglx.de/projects/hrtimers/2.6.23-rc7/patch-2.6.23-rc7-hrt1.patch
>
> works for you ?

Yes, powers off normally.

Torsten
