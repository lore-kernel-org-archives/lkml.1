Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbXGKBxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbXGKBxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 21:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbXGKBx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 21:53:29 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:20671 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbXGKBx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 21:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g2d7Lrgwa/hc0ZrU6uFvbU25NZJf2eQY8T0lts8THaT1Szv/qjQsuyrtC9ydh5fsJYH7c5r9QTD+H+TCh4FZ1ybIgvnH50ll/XHWhf2azw3iHO9SppZeenXCbJs9jj0o7tNWhoOzvrqhSs7cVRYDToS8MB9qwXTd68eHH6c9XxI=
Message-ID: <b8bf37780707101853v58ed213bp5b65cd829e020169@mail.gmail.com>
Date: Tue, 10 Jul 2007 22:53:26 -0300
From: "=?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?=" <andre.goddard@gmail.com>
To: "linux list" <linux-kernel@vger.kernel.org>
Subject: Fwd: [ck] Re: -mm merge plans for 2.6.23
In-Reply-To: <b8bf37780707101852g25d835b4ubbf8da5383755d4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
	 <b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
	 <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
	 <b8bf37780707101852g25d835b4ubbf8da5383755d4b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>  On Wed, 11 Jul 2007 11:02:56 +1000 "Matthew Hawkins" <darthmdh@gmail.com> wrote:
>
> > We all know swap prefetch has been tested out the wazoo since Moses was a
> > little boy, is compile-time and runtime selectable, and gives an important
> > and quantifiable performance increase to desktop systems.
>
> Always interested.  Please provide us more details on your usage and
> testing of that code.  Amount of memory, workload, observed results,
> etc?
>
>

It keeps my machine responsive after some time of inactivity,
i.e.  when I try to use firefox in the morning after leaving it running
overnight with multiple tabs open. I have 1Gb of memory in this machine.

With regards,
-- 
[]s,
André Goddard
