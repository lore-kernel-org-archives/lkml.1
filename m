Return-Path: <linux-kernel-owner+w=401wt.eu-S1764203AbYEFOth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764203AbYEFOth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbYEFOt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:49:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:28191 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbYEFOt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iiDxYWlhMYESdWtYUOdRIuGGVGmCeKmO5Ll+Al3eobqKKQarlKPt9eIcP69orsvxG0Oqc3eKNdwLWz45ay4fgU7I7ki3nf3LVbedLAhif26t6CoDMDvyhl1g2Qh7HPsym6qGJ3VlmFGIzVNjdi2GlLiAyeq3qucvHCq2aOJMQMs=
Message-ID: <8bd0f97a0805060749j28cb6fe6wfbdf0d3948d2f417@mail.gmail.com>
Date: Tue, 6 May 2008 10:49:04 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: monstr@seznam.cz
Subject: Re: LTP for no MMU systems
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, "Arnd Bergmann" <arnd@arndb.de>
In-Reply-To: <48206ECF.9090005@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48206ECF.9090005@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 10:44 AM, Michal Simek <monstr@seznam.cz> wrote:
>  I tested Microblaze MMU kernel for finding where could be problem. I have no
>  problem with compilation. Microblaze MMU test result is on
>  http://www.monstr.eu/wiki/doku.php?id=kernel:testing.
>
>  I would like to test no MMU kernel too. Does anyone use it for no MMU kernel?
>  (Blackfin, m68k and others)

yes, we run many of the tests under testcases/kernel/ on Blackfin
-mike
