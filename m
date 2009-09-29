Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbZI2RcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbZI2RcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 13:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZI2RcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 13:32:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:4210 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZI2RcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 13:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=q5BoIO6gwCTG2aA9lVk6bOu3wafFUtzMGDX1WH1dc88vzF8oFmh75FL9tbkCSyOTWR
         UMaZ9bXqAllI7FBvwl6fon1qpnwL4y3OWiKdmtwdCzQCztaWma6lH0ZiUB4wm1thKpKK
         AwbUqTjd5dOCBwd2BuaVWtdOFVq/YRj8nMgX4=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and earlier.
Date: Tue, 29 Sep 2009 19:32:17 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31.1r4; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200908211814.56800.volkerarmin@googlemail.com> <200909192211.12226.volkerarmin@googlemail.com> <86802c440909192303j643d83b5te710926a99ddb2e5@mail.gmail.com>
In-Reply-To: <86802c440909192303j643d83b5te710926a99ddb2e5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909291932.17282.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sonntag 20 September 2009, Yinghai Lu wrote:
> your looks ok, because you got new CPU, and HW will set WB for [4G, TOM2)

so the memory beyond 4gb is covered but the coverage is not shown in 
/proc/mtrr?

Glück Auf,
Volker
