Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZCFWTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZCFWTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbZCFWTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:19:38 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32029 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755403AbZCFWTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:19:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AExQanPq0xz6I2Uht88pOQK26daH59z26y/Ltq7bZF6iUxDLQQ5bB0WFan+OGOpsm2CE6qpRTkm1Dvzf8aYFiPnRp6q8oKPw9Vq4o2dgaPZArw8VzB+m/nou4aZznOXLROFiQ8/lSA2szS7py9I2Nx6RvCF/5GFqCX0X/FX3rxY=  ;
X-YMail-OSG: kaoJjZYVM1lnwRpaYYBXIDRReDQHEsYEIv5kgHs19SuJKhZINCNOdX8OPuLBToAKlqO8efxIQtsWghCfe68ZAQSHw5UhioKHYiQJ_WVmf3d7c1vgawOJjj_wNjxO4NgpoAvMKyKFvRJ4S3nyjTbly6R_fYnTvFG7XjSOOQmNAO27z3FkecYfqrYOj6SF
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.29-rc7] leds-gpio: just ignore invalid GPIOs
Date: Fri, 6 Mar 2009 14:19:35 -0800
User-Agent: KMail/1.9.10
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, diego.dompe@ridgerun.com,
       jdk@ti.com
References: <200903051646.44364.david-b@pacbell.net> <20090306133733.9afe1c1c.akpm@linux-foundation.org>
In-Reply-To: <20090306133733.9afe1c1c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903061419.35528.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009, Andrew Morton wrote:
> All this code has changed a lot in linux.next.  Nothing applies and it
> goes beyond my fix-it-up preparedness.

Well that's just no fun.  :(

Unless someone else wants to handle that, I'm just going to
leave this version in my patch queue until those changes come
down from mainline and break it.  An updated version would
come sometime later.

- Dave

