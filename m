Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbYJGPMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbYJGPMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbYJGPLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:11:51 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:29600 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751552AbYJGPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:11:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eEWrGLbwvdTPQaBjsCIrrli54WytQxcbfGsxyTTjyF19mkAtj3yyb9FATANBfGdK0kdxqJWeZnLdjhQLc38CD28e5PqlNyrO9B0hcmJaOEMcdOZlVE3E+Jw0GXznQ8SoeYdaEtRPNKfDqHYnh5Fo6IAk7eKWpCraGXagJLjMgW8=  ;
X-YMail-OSG: LvWDzNoVM1mS0MghfaElXbapo_Tve.O5avCg1b2XBrllLCs3SV8SmHNsH_YLdz7_uft0umcAyrE0ylDDbXz.LpdznuO_v9QXqRntaLDEhsSmJPQRxIfaanYU4dHXGkVW.RpFK5pvJ1wgodQvFsWpRi9fdLllr0x8TBnHaGTqWzcDHNLs76s-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11207] VolanoMark regression with 2.6.27-rc1
Date: Wed, 8 Oct 2008 02:11:41 +1100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Miao Xie" <miaox@cn.fujitsu.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.S8B.b975IB@wind>
In-Reply-To: <yWwteD.A.S8B.b975IB@wind>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810080211.42210.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 October 2008 04:28, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11207
> Subject		: VolanoMark regression with 2.6.27-rc1
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-07-31 3:20 (66 days old)
> References	: http://marc.info/?l=linux-kernel&m=121747464114335&w=4
> Handled-By	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> 		  Peter Zijlstra <a.p.zijlstra@chello.nl>
> 		  Dhaval Giani <dhaval@linux.vnet.ibm.com>
> 		  Miao Xie <miaox@cn.fujitsu.com>

Curious: what's happening with this one, handlers? Any progress being made?
