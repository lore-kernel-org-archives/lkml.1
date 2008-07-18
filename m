Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYGRMJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYGRMJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYGRMJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:09:32 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:56024 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753756AbYGRMJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:09:31 -0400
Date: Fri, 18 Jul 2008 08:09:30 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080718120930.GA2916@bromo.msbb.uc.edu>
References: <20080717023538.GA18329@bromo.msbb.uc.edu> <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com> <20080717034418.GA18951@bromo.msbb.uc.edu> <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com> <20080717061825.GA19582@bromo.msbb.uc.edu> <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com> <20080718011532.GA30920@bromo.msbb.uc.edu> <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com> <20080718060935.GA32345@bromo.msbb.uc.edu> <86802c440807172322s5dabbd1bx297742d782e373d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807172322s5dabbd1bx297742d782e373d6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
   Do you see anything in the pci earlydump and the associated lspci --vvxxxx
output that sheds any light on why we have to clean up the dmi with your
mmconfig patch on a MacBookPro2? I am wondering if the BIOS information is
being misused by the linux kernel or if the BIOS is just buggy.
                  Jack

