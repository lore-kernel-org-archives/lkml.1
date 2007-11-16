Return-Path: <linux-kernel-owner+w=401wt.eu-S933872AbXKPVip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbXKPVip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762926AbXKPVia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:38:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:38561 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbXKPVi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:38:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=inoeusxa8UmE5PHpTBU1XjgVTQfFZ6tBr728y09XxKKhneWoUpJ30aVr++dct0tVwGlA4Jv3+Hl23OGiYmqkGWrDtsgeaRdLXkZfn4txKJgOtcLUK/1LV6LRh5FSAxiNS1HZK02q/cYDpsEdlkGm6wFPzcot4qFoCI1bPC6qwdU=
Date: Fri, 16 Nov 2007 22:38:15 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Martin Olsson <mnemo@minimum.se>
Cc: linux-kernel@vger.kernel.org,
       Ubuntu Devel Discuss <ubuntu-devel-discuss@lists.ubuntu.com>
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
Message-Id: <20071116223815.f5042072.diegocg@gmail.com>
In-Reply-To: <473E815F.30900@minimum.se>
References: <473E815F.30900@minimum.se>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Fri, 16 Nov 2007 21:51:27 -0800, Martin Olsson <mnemo@minimum.se> escribió:

> Dear kernel hackers,
> 
> This is a message from below 0x7FFFFFFF. Please look at this bug (it's 
> not a new concept but still):
> https://bugs.launchpad.net/ubuntu/+bug/163185

Can't see that page:
----------------------
Not allowed here

Sorry, you don't have permission to access this page. 
----------------


> CTRL-ALT-DEL to work. Maybe it's possible to set some kind of 
> MAX_PROCESS_COUNT for each user (I don't know) but it looks like this is 
> not done by default in many distros today?

Per-user process limits have been there for a long time, most of distros don't
use them and don't offer GUIs to configure them.
