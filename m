Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577Ab0ADXvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0ADXvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612Ab0ADXvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:51:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:52787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086Ab0ADXvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:51:45 -0500
Message-ID: <4B427EA4.3040706@kernel.org>
Date: Mon, 04 Jan 2010 15:49:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       NetDEV list <netdev@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: Subject: [PATCH 1/2] x86: get back 15 vectors
References: <4B347AEE.6030705@kernel.org> <20091228094707.GH24690@elte.hu>	<4B398ECD.1080506@kernel.org>	<4807377b1001031906s6b1ee576jc021da2642bb4147@mail.gmail.com>	<4B415E73.1050801@kernel.org> <4B419113.1090204@kernel.org>	<m1aawtlu6y.fsf@fess.ebiederm.org> <4B423B08.3010005@zytor.com>	<m1my0thelq.fsf@fess.ebiederm.org> <4B424305.7050803@kernel.org>	<4B4245FC.7070902@zytor.com> <4B424A5C.7080309@kernel.org> <m1y6kdbpad.fsf@fess.ebiederm.org> <4B425085.5040103@kernel.org> <4B42595E.9010404@zytor.com> <4B425BB7.90501@kernel.org> <4B425EB5.5080504@zytor.com> <4B426550.6000209@kernel.org> <4B4273D4.2080709@zytor.com> <4B427A8C.1040902@kernel.org> <4B427BF0.1040001@zytor.com>
In-Reply-To: <4B427BF0.1040001@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

why not start from 0x30, 0x38, 0x40, 0x48 ...
instead of 0x31, 0x39, 0x41, 0x47...?

YH



