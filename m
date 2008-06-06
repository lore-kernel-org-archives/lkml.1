Return-Path: <linux-kernel-owner+w=401wt.eu-S1763320AbYFFPWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763320AbYFFPWx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 11:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762806AbYFFPW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 11:22:29 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52863 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761434AbYFFPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 11:22:28 -0400
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chris2553@googlemail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080605232538.fb85021e.akpm@linux-foundation.org>
References: <200806010415.05290.chris2553@googlemail.com>
	 <20080605221709.f248eb90.akpm@linux-foundation.org>
	 <200806060607.29460.chris2553@googlemail.com>
	 <20080605232145.cdae753f.akpm@linux-foundation.org>
	 <20080605232538.fb85021e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 10:22:22 -0500
Message-Id: <1212765742.16182.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-05 at 23:25 -0700, Andrew Morton wrote:
> On Thu, 5 Jun 2008 23:21:45 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > <watches wodim wibble for five minutes then report "CD/DVD-Recorder
> > not ready."  Pretends not to have noticed.>
> 
> It goes much better when the CD is inserted upside up.

So I can close this regression if I send you a pack of CD ring labels
with "other way up" on them for you to affix to the underside of your
CDs ... ?

James


