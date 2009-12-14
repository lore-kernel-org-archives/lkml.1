Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbZLNWxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbZLNWxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbZLNWxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:53:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344AbZLNWxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:53:42 -0500
Message-ID: <4B26C266.80202@gmail.com>
Date: Mon, 14 Dec 2009 23:55:34 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, jens.axboe@oracle.com
Subject: Re: [PATCH 0/3] Constify struct block_device_operations for	2.6.32-git-053fe57ac
 v2
References: <cover.1260662995.git.re.emese@gmail.com> <20091214101009.GA23742@8bytes.org>
In-Reply-To: <20091214101009.GA23742@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Mon, Dec 14, 2009 at 12:59:19AM +0100, re.emese@gmail.com wrote:
>> The following patch series attempts to constify several structures
>> that hold function pointers. This is only the initial batch, there
>> are about over 150 candidate structures, some of which can be
>> constified as well, I plan to submit them in the future.
> 
> Beside the fact that you posted two patch series in one thread all your
> patches lack a commit message. Please fix that.
> 
> 	Joerg

Sorry about it, git format-patch must have generated two identical
message IDs or I have a bug in my script, I will fix it and the
commit messages next time.
--
Emese

