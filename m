Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYAIEb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYAIEb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYAIEbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:31:50 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:39236 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYAIEbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:31:48 -0500
Message-ID: <47844E3B.8010603@nttdata.co.jp>
Date: Wed, 09 Jan 2008 13:31:55 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [TOMOYO #6 retry 08/21] Utility functions and policy manipulation
 interface.
References: <20080109005320.323184643@nttdata.co.jp> <20080109005421.598247963@nttdata.co.jp> <Xine.LNX.4.64.0801091524500.13216@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0801091524500.13216@us.intercode.com.au>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jan 2008 04:31:46.0201 (UTC) FILETIME=[8B059090:01C85278]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

James Morris wrote:
> Why aren't you using securityfs for this?  (It was designed for LSMs).
We are using securityfs mounted on /sys/kernel/security/ .
Thanks.

Kentaro Takeda

