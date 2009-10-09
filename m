Return-Path: <linux-kernel-owner+w=401wt.eu-S934520AbZJIVzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520AbZJIVzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934466AbZJIVzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:55:55 -0400
Received: from mx0.towertech.it ([213.215.222.73]:48259 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933132AbZJIVzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:55:54 -0400
Date: Fri, 9 Oct 2009 23:55:08 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, Hannes Eder <hannes@hanneseder.net>
Subject: Re: [PATCH] move stk17ta8's probe function to .devinit.text
Message-ID: <20091009235508.30c6c4a9@i1501.lan.towertech.it>
In-Reply-To: <alpine.LSU.2.00.0910092322250.19284@wotan.suse.de>
References: <20090711170548.GC5205@suse.de>
	<1247345591-22643-27-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-28-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-29-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-30-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-31-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-32-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-33-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-34-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-35-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-36-git-send-email-u.kleine-koenig@pengutronix.de>
	<1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de>
	<alpine.LSU.2.00.0910091724170.19284@wotan.suse.de>
	<20091009203319.28a220e6@i1501.lan.towertech.it>
	<alpine.LSU.2.00.0910092322250.19284@wotan.suse.de>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 23:22:52 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> It was probably sent only to you personally ...

 Always Cc the mailing list, that way it will enter patchwork.
 I'm bad enough at patch tracking and patchwork gives a nice help ;)


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

