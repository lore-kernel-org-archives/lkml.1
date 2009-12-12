Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZLMBji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZLMBji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbZLMBjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:39:36 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33217 "HELO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751247AbZLMBjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:39:36 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5829"; a="29735340"
Subject: Re: tree with htc dream support
From: Daniel Walker <dwalker@codeaurora.org>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Brian Swetland <swetland@google.com>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org
In-Reply-To: <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
References: <20091205221100.GA32522@elf.ucw.cz>
	 <1260054737.23633.35.camel@desktop>
	 <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
	 <d6200be20912112142r7bdf8f18o31edd4457aa64998@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 06:18:02 -0800
Message-Id: <1260627482.20913.7.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 21:42 -0800, Arve Hjønnevåg wrote:
> On Sat, Dec 5, 2009 at 4:38 PM, Brian Swetland <swetland@google.com> wrote:
> > Arve's about to take our common and msm trees and rebase them over the .32,
> > which may be useful for reference -- at least as a snapshot of a fully
> > functional set of patches that android donut and eclair run on, on
> > production hardware.  We'll make that available as soon as we have something
> > that's bootable.
> >
> > Brian
> >
> >
> 
> A first pass of this is available in the android-msm-2.6.32-test1
> branch at git://android.git.kernel.org/kernel/experimental.git.
> 
> http://android.git.kernel.org/?p=kernel/experimental.git;a=shortlog;h=refs/heads/android-msm-2.6.32-test1


Does this have the the newest wakelock code in it? From the all the
re-writes that you've done.

Daniel

