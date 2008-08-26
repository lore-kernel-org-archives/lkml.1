Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYHZOON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYHZOON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYHZON6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:13:58 -0400
Received: from mx0.towertech.it ([213.215.222.73]:52772 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752309AbYHZON5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:13:57 -0400
Date: Tue, 26 Aug 2008 16:13:53 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: will.newton@gmail.com, "Steven A. Falco" <sfalco@harris.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [RFC] Driver for Real Time Clock chip ST M41T65
Message-ID: <20080826161353.6326f6e2@i1501.lan.towertech.it>
In-Reply-To: <87a5b0800808260700g52cedf59kb07880ae05a104b@mail.gmail.com>
References: <48B2EB77.9000103@harris.com>
	<87a5b0800808260130i383ec8d0y45690f85366c5059@mail.gmail.com>
	<48B40B68.1040607@harris.com>
	<87a5b0800808260700g52cedf59kb07880ae05a104b@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008 15:00:03 +0100
"Will Newton" <will.newton@gmail.com> wrote:


> >> On Mon, Aug 25, 2008 at 6:27 PM, Steven A. Falco <sfalco@harris.com> wrote:
> >>> I will be using a Real Time Clock chip, ST M41T65, on a new embedded system.
> >>> The chip is quite similar to the M41T8x family, which already has driver
> >>> rtc-m41t80.c.
> >>>
> >>> Would it be more acceptible to generalize rtc-m41t80.c (perhaps renaming it to
> >>> rtc-m41txx.c) or would it be better to create a new rtc-m41t6x.c?
> >
> > Thanks for the feedback.  Here is a respin which addresses your comments.
> >
> > I'd also like to know if I should submit a new driver or mod the existing
> > one.  If I mod the existing one, should it be renamed, should I update the
> > Kconfig, existing defconfigs, etc?

 Given the small amount of changes, I would use the existing driver without
 renaming it.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

