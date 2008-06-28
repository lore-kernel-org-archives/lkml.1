Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbYF1DkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbYF1DkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 23:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYF1DkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 23:40:07 -0400
Received: from web50107.mail.re2.yahoo.com ([206.190.38.35]:34575 "HELO
	web50107.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752421AbYF1DkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 23:40:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=J/4F+4faI7RyoG1dNbkNIkNPNn6ckHHbaQo74rdulO2EbdqjsROl8QHPN6IDnEyXPSGAUMNKJxYSCwtR5Pg3puBmMFp1sVhgBIALN+Mh2fjyDsc0itEA7U3Od9witkVg6tU6l2QhgznOLopL4AHoDVyJbIO3/hlUYy9NZq7tLtI=;
X-YMail-OSG: M238iFUVM1mM4bBrb2sMbXmofE_PgRZ087UcfssXu5XENOk4c.c0yLl6hckrrLV2HUZdZl185TDoLDuJNycS3S8QKpdAYgKkhmbrRQaFtxO12QzpGdL6tFpgMZOrUb8XUA--
Date: Fri, 27 Jun 2008 20:40:04 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 4/13] EDAC i5100 fix unmask ecc bits
To: Andrew Morton <akpm@linux-foundation.org>, dougthompson@xmission.com
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20080627160641.70794381.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <762628.13634.qm@web50107.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andrew Morton <akpm@linux-foundation.org> wrote:

> So... is there any reason why we shouldn't fold patches 2, 3 and 4 into #1?
> 

I pondered that myself. I suppose since it is a new driver, then those mods could be folded in. I
got the original sometime ago and received the updates over time, as I let it stew for awhile,
expecting some updates. 

They could be folded together, yes

doug t


W1DUG
