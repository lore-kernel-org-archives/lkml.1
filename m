Return-Path: <linux-kernel-owner+w=401wt.eu-S1757670AbZDEEZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670AbZDEEZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 00:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbZDEEZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 00:25:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:44828 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbZDEEZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 00:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=nDOFtrLHgbPO5UnPc9qIV+W3Gzr/LkuwVKYLmrlFTum3tBNkYh+n7Cb7s1JKCMeWt8
         Nvk0H9ohFjpya3T8N4hKRaJkh+KZtW6HyUpgrZHT9vpfk244WlCxz6S1EH1EJm96epNW
         /3cDds5cUdbQsS2Xt3mr8gts5tO4hc0+P0d/c=
MIME-Version: 1.0
In-Reply-To: <9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com>
References: <9b1675090904041103v477913a5of06fa5c10ebee05f@mail.gmail.com>
	 <9b1675090904041131u28635d8dnc3d13e88000394b4@mail.gmail.com>
	 <20090405011355.GE7553@mit.edu>
	 <9b1675090904042117k77463227y66a872d52d027e7e@mail.gmail.com>
Date: Sat, 4 Apr 2009 22:25:12 -0600
Message-ID: <9b1675090904042125g708076e6v665f5ecc7fa020a4@mail.gmail.com>
Subject: Re: IO latency - a special case
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Theodore Tso <tytso@mit.edu>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more quick thing.  is it okay if I filter on "trace=futex" only,
or do you want something more?
