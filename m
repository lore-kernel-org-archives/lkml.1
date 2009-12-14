Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbZLNBbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbZLNBbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbZLNBbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:31:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43939 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbZLNBbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:31:34 -0500
Message-ID: <4B2595E7.701@gmail.com>
Date: Mon, 14 Dec 2009 02:33:27 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH 0/1] Constify struct address_space_operations for 2.6.32-git-053fe57ac
 v2
References: <cover.1260662994.git.re.emese@gmail.com> <20091214003836.GD7812@parisc-linux.org>
In-Reply-To: <20091214003836.GD7812@parisc-linux.org>
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

Matthew Wilcox wrote:
> On Mon, Dec 14, 2009 at 12:59:08AM +0100, re.emese@gmail.com wrote:
>> From: Emese Revfy <re.emese@gmail.com>
>>
>> Hello everyone!
>>
>> The following patch series attempts to constify several structures
>> that hold function pointers. This is only the initial batch, there
>> are about over 150 candidate structures, some of which can be
>> constified as well, I plan to submit them in the future.
> 
> What a complete waste of time.  Until you respond to Al's:

I did: http://lkml.org/lkml/2009/12/5/140

For even more discussion see: http://lkml.org/lkml/2009/12/6/111

--
Emese
