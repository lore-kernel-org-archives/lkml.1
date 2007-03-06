Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbXCFKfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbXCFKfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934027AbXCFKfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:35:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39650 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026AbXCFKfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:35:39 -0500
Subject: Re: PROBLEM: 2.6.20-1 not working on ibook g4 (BUG/Oops)
From: David Woodhouse <dwmw2@infradead.org>
To: Paul Collins <paul@briny.ondioline.org>
Cc: francesco foresti <frafore@tiscali.it>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <87tzwzqgrx.fsf@briny.internal.ondioline.org>
References: <200703051414.15802.frafore@tiscali.it>
	 <1173143894.3461.240.camel@pmac.infradead.org>
	 <87tzwzqgrx.fsf@briny.internal.ondioline.org>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 10:35:29 +0000
Message-Id: <1173177329.3461.291.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 14:53 +1300, Paul Collins wrote:
> In case it's of interest, 2.6.20 has been running fine on my
> PowerBook5,4. 

How much memory? What if you boot with mem=512M or mem=256M?

It works fine on my PowerBook5,3 unless I do that.

-- 
dwmw2

