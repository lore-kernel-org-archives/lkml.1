Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbYIWCOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbYIWCOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 22:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYIWCOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 22:14:38 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:4146 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbYIWCOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 22:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Iv6iZ6ymOZuOJYFQosTg9anXGHkH71tr0Bd+jHmYew013a1jx+CiA+ftNX59t/MGYO
         qME6fruP+BYzaxJ2zQ4uzFaU4FogH/6rV5H7qDgy+RMeTM7wDGg1iIgFgqd8iSboAM/B
         leoMTuPoVwn/u4e010xcd3pBeNkVHYGRYVBr4=
Date: Mon, 22 Sep 2008 21:13:51 -0500
From: Andy Wettstein <ajw1980@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11568] spontaneous reboot on resume with 2.6.27
Message-ID: <20080923021351.GA18533@bob>
References: <PJz8fNrJNHG.A.65F.wzq1IB@albercik> <7lIhZC4hCxE.A.DYG.N0q1IB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7lIhZC4hCxE.A.DYG.N0q1IB@albercik>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 08:54:21PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11568
> Subject		: spontaneous reboot on resume with 2.6.27
> Submitter	: Andy Wettstein <ajw1980@gmail.com>
> Date		: 2008-09-14 20:00 (8 days old)

Just verified it is still a problem with 2.6.27-rc7.

