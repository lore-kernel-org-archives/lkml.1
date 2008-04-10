Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYDJMnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYDJMnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbYDJMnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:43:07 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54401 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbYDJMnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:43:07 -0400
Subject: Re: Does Linux have plan to support memory hole remapping?
From: Kasper Sandberg <lkml@metanurb.dk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matti Aarnio <matti.aarnio@zmailer.org>,
       Zhao Forrest <forrest.zhao@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       ak@suse.de
In-Reply-To: <47FD76C0.4010603@zytor.com>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
	 <87iqyro3rc.fsf@basil.nowhere.org>
	 <20080409083700.GU3700@mea-ext.zmailer.org>
	 <20080409085440.GB32466@elte.hu> <1207787687.30698.97.camel@localhost>
	 <47FD76C0.4010603@zytor.com>
Content-Type: text/plain
Date: Thu, 10 Apr 2008 14:41:36 +0200
Message-Id: <1207831296.1514.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 19:09 -0700, H. Peter Anvin wrote:
> Kasper Sandberg wrote:
> > A somewhat related question is.. How come linux does not(as i understand
> > it) support talking to the chipsets to do these things? wouldnt this
> > also give other benefits, such as being able to more precisely control
> > interrupts and stuff?
> 
> Sure.  Plus, it's virtually guaranteed to crash or corrupt your system 
> if you try to do anything which requires ACPI or SMM.
Ah, i just thought that a specific other OS actually did this (which,
now that you mention this, makes a whole lot of sense :-))
> 
> 	-hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

