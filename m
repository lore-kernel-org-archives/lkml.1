Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYJGPXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYJGPXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYJGPXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:23:14 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:47614 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752764AbYJGPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:23:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gSyDOulDnRZNI/rMr3eI9nQfy4BRj81jHJgY9B5h/YlcyfOHIS5OAIYN9RSQIEHHudDqeYnCYfQeavWqfa2accPwqTE169UWd47Lb07mSlxL9S7wFbuRHJ5cWP1b//QZ0zaEYFWEEjJuh/Jq7n72D59wSoUAeCw+G3B+Y/OtwFE=  ;
X-YMail-OSG: 47StDAMVM1mNxcPCO9BwleCbpXuZD7Jxm4HnnD15_OskR_EgpsgVaJZpvAeETTE2OLeufc5nI8y5NDGZUts_XNQPJfqtsffmsdCJr9CzgEpPVAyWVYuaHoR5BGjkkAUH394crphRl9BTyVl3EPwtvkVQ64yCtgi28DqRxmKemuclGhru7Xg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, davej@codemonkey.org.uk,
       oleg@tv-sign.ru
Subject: Re: [Bug #11264] Invalid op opcode in kernel/workqueue
Date: Wed, 8 Oct 2008 02:23:03 +1100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Jean-Luc Coulon" <jean.luc.coulon@gmail.com>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.oLB.b875IB@wind>
In-Reply-To: <yWwteD.A.oLB.b875IB@wind>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080223.03395.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 October 2008 04:32, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11264
> Subject		: Invalid op opcode in kernel/workqueue
> Submitter	: Jean-Luc Coulon <jean.luc.coulon@gmail.com>
> Date		: 2008-08-07 04:18 (59 days old)

Any progress being made with this one? Dave, Oleg did some pretty
nice looking debugging work that indicates it might be a cpufreq
problem. Have you had a chance to look at the comments in the
bugzilla? Or have you been cc'ed on patches for this?

Thanks,
Nick
