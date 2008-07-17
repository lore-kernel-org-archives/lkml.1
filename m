Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYGQQ0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYGQQ0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 12:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbYGQQ00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 12:26:26 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:33403 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756214AbYGQQ00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 12:26:26 -0400
Date: Thu, 17 Jul 2008 12:26:22 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080717162622.GA26835@bromo.msbb.uc.edu>
References: <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com> <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com> <20080717004004.GA17792@bromo.msbb.uc.edu> <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com> <20080717023538.GA18329@bromo.msbb.uc.edu> <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com> <20080717034418.GA18951@bromo.msbb.uc.edu> <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com> <20080717061825.GA19582@bromo.msbb.uc.edu> <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
   I am wondering if it might be worthwhile for me to
try the various rc releases of 2.6.26 (starting with rc1-git1)
to see if I can identify at what point 2.6.26 was broken
with regards to booting on my MacBook Pro? In case that
would point us towards the checkin of a specific set of
patches as the problem.
                      Jack
