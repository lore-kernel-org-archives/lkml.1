Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0BIH3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 02:29:46 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:47012 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab0BIH3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 02:29:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x2JkRkBHauiI6HHrrgbfD6juPc5Z5KxiOWTUmCuXN5wQv6yCkCD+bzfxYSs0FmpvUT
         nVnfIsBnsaFAiwkJ1yI1Qje3/rB/mcldJSBuUIRweg2CiIbDzR5ERnJFm2YeZP2624k7
         GjD07GjmwVG7/PBu5yU9B4DN3+juzHku4lRcU=
MIME-Version: 1.0
In-Reply-To: <4807377b1002081543p33e13f0bv140141316ff6278f@mail.gmail.com>
References: <2uzMDuY-7_O.A.M1G.7X1bLB@chimera>
	 <iuJeop2ribM.A.o7H.jY1bLB@chimera>
	 <4807377b1002081543p33e13f0bv140141316ff6278f@mail.gmail.com>
Date: Mon, 8 Feb 2010 23:29:43 -0800
Message-ID: <4807377b1002082329h957d2d0u38be88fdd940ceac@mail.gmail.com>
Subject: Re: [Bug #15042] socket(PF_INET6 hangs when ipv6 not yet initialized
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Marc Haber <mh+linux-kernel@zugschlus.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 8, 2010 at 3:43 PM, Jesse Brandeburg
<jesse.brandeburg@gmail.com> wrote:
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15042
>> Subject         : socket(PF_INET6 hangs when ipv6 not yet initialized
>> Submitter       : Marc Haber <mh+linux-kernel@zugschlus.de>
>> Date            : 2010-01-10 14:28 (29 days old)
>> References      : http://marc.info/?l=linux-kernel&m=126313553029280&w=4
>
> probably fixed by this patch:
> http://marc.info/?l=linux-netdev&m=126565759512718&w=2

wow, scratch that, wrong bug I picked to reply to.  sorry!
